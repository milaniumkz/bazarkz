const {initializeTestEnvironment} = require('@firebase/rules-unit-testing');
const {doc,setDoc,getDoc} = require('firebase/firestore');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const project='demo-bazarkz-auth';
const authBase='http://127.0.0.1:9097/identitytoolkit.googleapis.com/v1/';
async function post(url,data,token) {
  const response=await fetch(url,{method:'POST',headers:{'Content-Type':'application/json',...(token?{Authorization:`Bearer ${token}`}:{})},body:JSON.stringify(data)});
  return {status:response.status,body:await response.json()};
}
(async()=>{
  const env=await initializeTestEnvironment({projectId:project,firestore:{host:'127.0.0.1',port:8087,rules:fs.readFileSync('firestore.rules','utf8')}});
  try {
    const legacy='+7 (701) 123-45-67';
    await env.withSecurityRulesDisabled(async context=>{
      const db=context.firestore();
      await setDoc(doc(db,'users',legacy),{uid:legacy,display_name:'Existing buyer',city:'Алматы',favorites:['preserve-me']});
      await setDoc(doc(db,'users','other-user'),{display_name:'Private'});
    });
    const endpoint=`http://127.0.0.1:5007/${project}/us-central1/finalizeBuyerPhoneSignIn`;
    const rejected=await post(endpoint,{data:{uid:legacy}});
    assert.equal(rejected.status,401);
    const sent=await post(authBase+'accounts:sendVerificationCode?key=fake',{phoneNumber:'+77011234567',recaptchaToken:'emulator'});
    assert.equal(sent.status,200);
    const codes=await (await fetch(`http://127.0.0.1:9097/emulator/v1/projects/${project}/verificationCodes`)).json();
    const code=codes.verificationCodes.find(x=>x.phoneNumber==='+77011234567').code;
    const wrong=await post(authBase+'accounts:signInWithPhoneNumber?key=fake',{sessionInfo:sent.body.sessionInfo,code:code==='000000'?'111111':'000000'});
    assert.notEqual(wrong.status,200);
    const signed=await post(authBase+'accounts:signInWithPhoneNumber?key=fake',{sessionInfo:sent.body.sessionInfo,code});
    assert.equal(signed.status,200);
    const exchanged=await post(endpoint,{data:{}},signed.body.idToken);
    assert.equal(exchanged.status,200,JSON.stringify(exchanged.body));
    const result=await post(authBase+'accounts:signInWithCustomToken?key=fake',{token:exchanged.body.result.token,returnSecureToken:true});
    assert.equal(result.status,200);
    const claims=JSON.parse(Buffer.from(result.body.idToken.split('.')[1],'base64url').toString());
    assert.equal(claims.sub,legacy,'Migration must preserve the original UID');
    assert.equal(claims.buyerPhoneVerified,true);
    const db=env.authenticatedContext(legacy,{firebase:{sign_in_provider:'custom'},buyerPhoneVerified:true}).firestore();
    assert.equal((await getDoc(doc(db,'users',legacy))).data().favorites[0],'preserve-me');
    await assert.rejects(getDoc(doc(db,'users','other-user')));
    const spoof=await post(endpoint,{data:{uid:'other-user'}},result.body.idToken);
    assert.equal(spoof.status,401,'A custom token must not be reused as a phone verification proof');
    await env.withSecurityRulesDisabled(async context=>{
      const db=context.firestore();
      await setDoc(doc(db,'order','retained-order'),{idUser:doc(db,'users',legacy),tel:'+77011234567',adres:'Test address',summa:42});
      await setDoc(doc(db,'chats','retained-chat'),{users:[doc(db,'users',legacy),doc(db,'users','other-user')],user_a:doc(db,'users',legacy),user_b:doc(db,'users','other-user'),last_message:'Keep other person message',last_message_sent_by:doc(db,'users','other-user')});
    });
    const deleted=await post(endpoint.replace('finalizeBuyerPhoneSignIn','deleteOwnAccount'),{data:{}},result.body.idToken);
    assert.equal(deleted.status,200,JSON.stringify(deleted.body));
    await env.withSecurityRulesDisabled(async context=>{
      const db=context.firestore();
      assert.equal((await getDoc(doc(db,'users',legacy))).exists(),false);
      assert.equal((await getDoc(doc(db,'users','other-user'))).exists(),true);
      const order=(await getDoc(doc(db,'order','retained-order'))).data();
      assert.equal(order.summa,42);assert.equal(order.idUser,undefined);assert.equal(order.tel,undefined);assert.equal(order.adres,undefined);
      const chat=(await getDoc(doc(db,'chats','retained-chat'))).data();
      assert.equal(chat.last_message,'Keep other person message');assert.equal(chat.users.length,1);assert.equal(chat.user_a,undefined);assert.equal(chat.user_b.id,'other-user');
    });
    console.log('PASS: SMS proof → Cloud Function → preserved legacy UID; data retained; wrong codes, other-user reads and UID spoofing rejected.');
    console.log('PASS: Own-account deletion removes own profile, anonymizes retained orders and preserves other users and their chat messages.');
  } finally { await env.cleanup(); }
})().catch(error=>{console.error(error);process.exitCode=1;});
