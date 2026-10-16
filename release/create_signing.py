"""Generate fresh release keys without printing passwords; never overwrite keys."""
import json
import os
from pathlib import Path
import secrets
import subprocess

root = Path(__file__).resolve().parents[1]
vault = root / '.release-private' / '2026-10-15'
vault.mkdir(parents=True, exist_ok=True, mode=0o700)
os.chmod(vault.parent, 0o700)
os.chmod(vault, 0o700)
keytool = '/Volumes/PD1000/Программы/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool'
for project, alias in [('bazar_kz', 'bazarkz-buyer-upload'), ('bazarkz_seller', 'bazarkz-seller-upload')]:
    key = vault / (alias + '.jks')
    credentials = vault / (alias + '.json')
    if key.exists() or credentials.exists():
        raise SystemExit(f'Refusing to overwrite existing signing data: {alias}')
    password = secrets.token_urlsafe(36)
    env = dict(os.environ, BAZARKZ_KEY_PASSWORD=password)
    subprocess.run([keytool, '-genkeypair', '-noprompt', '-keystore', str(key),
                    '-storetype', 'JKS', '-alias', alias, '-keyalg', 'RSA',
                    '-keysize', '4096', '-validity', '10000',
                    '-storepass:env', 'BAZARKZ_KEY_PASSWORD',
                    '-keypass:env', 'BAZARKZ_KEY_PASSWORD', '-dname', 'CN=BazarKz'],
                   env=env, check=True, capture_output=True)
    credentials.write_text(json.dumps({'alias': alias, 'storePassword': password,
                                      'keyPassword': password, 'storeFile': str(key)}, indent=2))
    properties = root / project / 'android' / 'key.properties'
    properties.write_text(f'storeFile={key}\nstorePassword={password}\nkeyPassword={password}\nkeyAlias={alias}\n')
    for file in [key, credentials, properties]:
        os.chmod(file, 0o600)
    subprocess.run([keytool, '-exportcert', '-rfc', '-keystore', str(key),
                    '-alias', alias, '-storepass:env', 'BAZARKZ_KEY_PASSWORD',
                    '-file', str(vault / (alias + '.pem'))],
                   env=env, check=True, capture_output=True)
    print(f'Created and saved: {alias}')
