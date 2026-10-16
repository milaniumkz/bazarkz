"""Use an existing Firebase CLI session without printing or persisting tokens."""
import json
import ssl
import subprocess
import urllib.request

PROJECT = 'ba-za-r-k-z-np0vyz'
CONTEXT = ssl.create_default_context(cafile='/opt/homebrew/etc/openssl@3/cert.pem')

def request(url, data=None, method=None):
    session = json.loads(subprocess.check_output(['firebase', 'login:list', '--json'], stderr=subprocess.DEVNULL))
    account = next(a for a in session['result'] if a['user']['email'] == 'itmilanium@gmail.com')
    headers = {'Authorization': 'Bearer ' + account['tokens']['access_token']}
    body = None
    if data is not None:
        headers['Content-Type'] = 'application/json'
        body = json.dumps(data).encode()
    req = urllib.request.Request(url, data=body, headers=headers, method=method)
    with urllib.request.urlopen(req, context=CONTEXT, timeout=45) as response:
        return json.load(response)
