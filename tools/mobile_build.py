"""Build only buyer/seller; secrets arrive from a protected GitHub environment."""
import base64
import json
import os
from pathlib import Path
import re
import secrets
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parent.parent
TEMP = Path(os.environ.get('RUNNER_TEMP', '/tmp')) / 'bazarkz-signing'

def run(*args, cwd=None):
    subprocess.run(args, cwd=cwd, check=True)

def clean():
    if sys.platform == 'darwin' and (TEMP / 'signing.keychain-db').exists():
        subprocess.run(['security', 'delete-keychain', str(TEMP / 'signing.keychain-db')], capture_output=True)
    for app in ('bazar_kz', 'bazarkz_seller'):
        (ROOT / app / 'android/key.properties').unlink(missing_ok=True)
    if TEMP.exists():
        shutil.rmtree(TEMP)

def write_private(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)
    path.chmod(0o600)

def main():
    if '--clean' in sys.argv:
        clean()
        return
    app = os.environ['APP']
    platform = os.environ['PLATFORM']
    version = os.environ['APP_VERSION']
    number = os.environ['BUILD_NUMBER']
    if app not in ('buyer', 'seller') or platform not in ('android', 'ios'):
        raise ValueError('Unsupported application/platform')
    if not re.fullmatch(r'\d+\.\d+\.\d+', version) or not re.fullmatch(r'[1-9]\d{0,8}', number):
        raise ValueError('Invalid version/build number')
    source = ROOT / ('bazar_kz' if app == 'buyer' else 'bazarkz_seller')
    TEMP.mkdir(mode=0o700, parents=True, exist_ok=True)
    if platform == 'ios':
        # Match the tested CocoaPods setup; current Flutter defaults to SPM.
        run('flutter', 'config', '--no-enable-swift-package-manager')
    run('flutter', 'pub', 'get', cwd=source)
    if platform == 'android':
        signing = json.loads(os.environ['ANDROID_SIGNING'])
        store = TEMP / 'upload.jks'
        write_private(store, base64.b64decode(signing['keystore']))
        fields = dict(storeFile=str(store), keyAlias=signing['alias'], storePassword=signing['storePassword'], keyPassword=signing['keyPassword'])
        def escape(value):
            return str(value).replace('\\', '\\\\').replace('\n', '\\n').replace('\r', '\\r').replace('=', '\\=').replace(':', '\\:')
        write_private(source / 'android/key.properties', ''.join(k+'='+escape(v)+'\n' for k,v in fields.items()).encode())
        run('flutter', 'build', 'appbundle', '--release', '--build-name='+version, '--build-number='+number, cwd=source)
        output = list((source / 'build/app/outputs/bundle/release').glob('*.aab'))
    else:
        signing = json.loads(os.environ['APPLE_SIGNING'])
        p12 = TEMP / 'distribution.p12'
        keychain = TEMP / 'signing.keychain-db'
        password = secrets.token_urlsafe(32)
        write_private(p12, base64.b64decode(signing['p12']))
        # Do not echo subprocess arguments: they contain temporary passwords.
        run('security', 'create-keychain', '-p', password, str(keychain))
        run('security', 'set-keychain-settings', '-lut', '21600', str(keychain))
        run('security', 'unlock-keychain', '-p', password, str(keychain))
        run('security', 'import', str(p12), '-P', signing['p12Password'], '-A', '-t', 'cert', '-f', 'pkcs12', '-k', str(keychain))
        run('security', 'set-key-partition-list', '-S', 'apple-tool:,apple:', '-k', password, str(keychain))
        run('security', 'list-keychains', '-d', 'user', '-s', str(keychain))
        profile_dir = Path.home() / 'Library/MobileDevice/Provisioning Profiles'
        profiles = ['APPLE_BUYER_PROFILE'] if app == 'buyer' else ['APPLE_SELLER_PROFILE', 'APPLE_NOTIFICATION_PROFILE']
        for name in profiles:
            write_private(profile_dir / (name+'.mobileprovision'), base64.b64decode(os.environ[name]))
        run('flutter', 'build', 'ipa', '--release', '--build-name='+version, '--build-number='+number, '--export-options-plist='+str(ROOT / ('release/ExportOptions-'+app+'.plist')), cwd=source)
        output = list((source / 'build/ios/ipa').glob('*.ipa'))
    if len(output) != 1:
        raise RuntimeError('Expected exactly one signed artifact')
    dest = ROOT / 'dist'
    dest.mkdir(exist_ok=True)
    shutil.copyfile(output[0], dest / ('bazarkz-'+app+output[0].suffix))

if __name__ == '__main__':
    try:
        main()
    except subprocess.CalledProcessError:
        # CalledProcessError includes command arguments; suppress secret values.
        print('Build/signing command failed; inspect preceding tool output.', file=sys.stderr)
        sys.exit(1)
