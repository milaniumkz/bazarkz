"""Exercise only the configured Firebase review phone; never send a real SMS."""
import base64,json,re,urllib.request,urllib.error
from pathlib import Path
from google_api import CONTEXT
root=Path(__file__).resolve().parent.parent
vault=root/'.release-private/2026-10-15'
account=json.loads((vault/'buyer-review-account.json').read_text())
source=(root/'bazar_kz/lib/backend/firebase/firebase_config.dart').read_text()
key=re.search(r"apiKey: ['\"]([^'\"]+)",source).group(1)
def post(url,data,token=None):
    headers={'Content-Type':'application/json'}
    if token:headers['Authorization']='Bearer '+token
    try:
        return json.load(urllib.request.urlopen(urllib.request.Request(url,data=json.dumps(data).encode(),headers=headers),context=CONTEXT,timeout=45))
    except urllib.error.HTTPError as error:
        detail=json.load(error).get('error',{}).get('message')
        raise SystemExit(f'HTTP {error.code}: {detail}')
base='https://identitytoolkit.googleapis.com/v1/accounts:'
session=post(base+'sendVerificationCode?key='+key,{'phoneNumber':account['phone'],'recaptchaToken':'test'})
phone=post(base+'signInWithPhoneNumber?key='+key,{'sessionInfo':session['sessionInfo'],'code':account['code']})
result=post('https://us-central1-ba-za-r-k-z-np0vyz.cloudfunctions.net/finalizeBuyerPhoneSignIn',{'data':{}},phone['idToken'])
user=post(base+'signInWithCustomToken?key='+key,{'token':result['result']['token'],'returnSecureToken':True})
claims=json.loads(base64.urlsafe_b64decode(user['idToken'].split('.')[1]+'=='))
assert claims.get('buyerPhoneVerified') is True
path=vault/'phone-test-result.json';path.write_text(json.dumps(user));path.chmod(0o600)
print('PASS: Google phone proof → deployed Cloud Function → Firebase signed-in user with verified buyer claim.')
