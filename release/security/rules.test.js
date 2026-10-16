const {before, after, test} = require('node:test');
const fs = require('node:fs');
const {initializeTestEnvironment, assertSucceeds, assertFails} = require('@firebase/rules-unit-testing');
const {doc, setDoc, getDoc, updateDoc, collection, query, where, getDocs} = require('firebase/firestore');
let env;
before(async () => {
  env = await initializeTestEnvironment({projectId:'demo-bazarkz-auth',firestore:{host:'127.0.0.1',port:8087,rules:fs.readFileSync('firestore.rules','utf8')}});
  await env.withSecurityRulesDisabled(async context => {
    const db=context.firestore();
    await setDoc(doc(db,'users/alice'),{uid:'alice',display_name:'Alice',admin:false});
    await setDoc(doc(db,'users/bob'),{uid:'bob',display_name:'Bob'});
    await setDoc(doc(db,'_accessRoles/admin'),{role:'admin'});
    await setDoc(doc(db,'_accessRoles/seller'),{role:'seller'});
    await setDoc(doc(db,'shopSkidki/shop'),{idPartner:doc(db,'users/seller')});
    await setDoc(doc(db,'order/order'),{idUser:doc(db,'users/alice'),summa:100,status:0});
  });
});
after(async()=>{if(env)await env.cleanup();});
const buyer = uid => env.authenticatedContext(uid,{firebase:{sign_in_provider:'custom'},buyerPhoneVerified:true}).firestore();
const email = uid => env.authenticatedContext(uid,{firebase:{sign_in_provider:'password'}}).firestore();
test('unauthenticated requests cannot read profiles or orders',async()=>{
  const db=env.unauthenticatedContext().firestore();
  await assertFails(getDoc(doc(db,'users/alice')));
  await assertFails(getDoc(doc(db,'order/order')));
  await assertSucceeds(getDoc(doc(db,'shopSkidki/shop')));
});
test('old custom-token endpoint cannot impersonate a buyer or administrator',async()=>{
  for(const uid of ['alice','admin']) {
    const db=env.authenticatedContext(uid,{firebase:{sign_in_provider:'custom'}}).firestore();
    await assertFails(getDoc(doc(db,'users/alice')));
    await assertFails(updateDoc(doc(db,'users/alice'),{admin:true}));
  }
});
test('verified buyer owns only their profile and cannot grant privileges',async()=>{
  const db=buyer('alice');
  await assertSucceeds(getDoc(doc(db,'users/alice')));
  await assertFails(getDoc(doc(db,'users/bob')));
  await assertSucceeds(updateDoc(doc(db,'users/alice'),{display_name:'Updated'}));
  await assertFails(updateDoc(doc(db,'users/alice'),{admin:true}));
  await assertFails(setDoc(doc(db,'_accessRoles/alice'),{role:'admin'}));
  await assertSucceeds(getDocs(query(collection(db,'order'),where('idUser','==',doc(db,'users/alice')))));
});
test('seller cannot create a shop under another owner',async()=>{
  const db=email('seller');
  await assertSucceeds(setDoc(doc(db,'shopSkidki/owned'),{idPartner:doc(db,'users/seller')}));
  await assertFails(setDoc(doc(db,'shopSkidki/stolen'),{idPartner:doc(db,'users/bob')}));
});
test('existing administrator keeps management access',async()=>{
  const db=email('admin');
  await assertSucceeds(getDoc(doc(db,'users/alice')));
  await assertSucceeds(updateDoc(doc(db,'users/bob'),{partner:true,role:'1'}));
});
test('chat reports are private and blocking prevents reinvitation and new conversations',async()=>{
  const alice=buyer('alice'),bob=buyer('bob');
  const users=[doc(alice,'users/alice'),doc(alice,'users/bob')];
  const chat={users,user_a:users[0],user_b:users[1]};
  await assertSucceeds(setDoc(doc(alice,'chats/safety'),chat));
  await assertSucceeds(setDoc(doc(alice,'contentReports/report'),{sender:users[0],target:users[1],chat:doc(alice,'chats/safety'),reason:'Test report',createdAt:new Date()}));
  await assertFails(getDoc(doc(bob,'contentReports/report')));
  await assertSucceeds(getDoc(doc(email('admin'),'contentReports/report')));
  await assertSucceeds(updateDoc(doc(alice,'users/alice'),{blocked_users:[users[1]]}));
  await assertFails(setDoc(doc(bob,'chat_messages/blocked'),{chat:doc(bob,'chats/safety'),user:doc(bob,'users/bob'),text:'Not delivered'}));
  await assertFails(setDoc(doc(bob,'chats/retry'),{users,user_a:users[1],user_b:users[0]}));
  await assertSucceeds(updateDoc(doc(alice,'chats/safety'),{users:[users[1]]}));
  await assertFails(updateDoc(doc(bob,'chats/safety'),{users}));
});
test('objectionable message text is rejected by the server',async()=>{
  const db=buyer('alice');
  await env.withSecurityRulesDisabled(async context=>{
    const admin=context.firestore();
    await updateDoc(doc(admin,'users/alice'),{blocked_users:[]});
    await setDoc(doc(admin,'chats/filter'),{users:[doc(admin,'users/alice'),doc(admin,'users/bob')]});
  });
  const message={chat:doc(db,'chats/filter'),user:doc(db,'users/alice'),text:'Здравствуйте!'};
  await assertSucceeds(setDoc(doc(db,'chat_messages/normal'),message));
  await assertFails(setDoc(doc(db,'chat_messages/rejected'),{...message,text:'купить наркотики'}));
});
