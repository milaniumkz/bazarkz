"""Fail CI when private operational files accidentally enter the public tree."""
from pathlib import Path
import re
import subprocess

files = subprocess.check_output(['git', 'ls-files', '-z']).decode().split('\0')
forbidden = re.compile(r'(^|/)(\.release-private|\.codex|node_modules|Pods|build|proofs|logs)(/|$)|\.(p8|p12|jks|keystore|key|mobileprovision|ipa|aab|apk|zip)$|(^|/)(key|local)\.properties$|(^|/)\.env(?:\.|$)')
errors = []
for name in filter(None, files):
    if forbidden.search(name):
        errors.append(name + ': forbidden private/generated path')
        continue
    path = Path(name)
    if path.is_symlink() or not path.is_file():
        continue
    try:
        text = path.read_text()
    except UnicodeError:
        continue
    if re.search(r'-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----', text):
        errors.append(name + ': private key')
    if re.search(r'gh[pousr]_[A-Za-z0-9]{30,}', text):
        errors.append(name + ': GitHub token')
if errors:
    raise SystemExit('\n'.join(errors))
print('PASS: no private operational paths or private keys in tracked files')
