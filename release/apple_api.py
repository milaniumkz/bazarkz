"""Use an existing authorized App Store Connect key without logging credentials."""
import base64,json,time,ssl,urllib.request
from pathlib import Path
from cryptography.hazmat.primitives.serialization import load_pem_private_key
from cryptography.hazmat.primitives.asymmetric import ec,utils
from cryptography.hazmat.primitives import hashes
ROOT=Path(__file__).resolve().parent.parent
CONTEXT=ssl.create_default_context(cafile='/opt/homebrew/etc/openssl@3/cert.pem')
def encoded(value):return base64.urlsafe_b64encode(value).rstrip(b'=')
def request(path,data=None,method=None):
    if not path.startswith(('/v1/','/v2/')):raise ValueError('Only official App Store Connect API resource paths are supported')
    config=json.loads((ROOT/'.release-private/2026-10-15/appstore-api-config.json').read_text())
    now=int(time.time());payload={'iss':config['issuerId'],'iat':now,'exp':now+300,'aud':'appstoreconnect-v1'}
    part=encoded(json.dumps({'alg':'ES256','kid':config['keyId'],'typ':'JWT'}).encode())+b'.'+encoded(json.dumps(payload).encode())
    key=load_pem_private_key(Path(config['keyPath']).read_bytes(),None)
    r,s=utils.decode_dss_signature(key.sign(part,ec.ECDSA(hashes.SHA256())))
    token=(part+b'.'+encoded(r.to_bytes(32,'big')+s.to_bytes(32,'big'))).decode()
    headers={'Authorization':'Bearer '+token}
    body=None
    if data is not None:headers['Content-Type']='application/json';body=json.dumps(data).encode()
    with urllib.request.urlopen(urllib.request.Request('https://api.appstoreconnect.apple.com'+path,data=body,headers=headers,method=method),context=CONTEXT,timeout=45) as response:
        raw=response.read();return json.loads(raw) if raw else {}
