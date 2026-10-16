"use strict";
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {initializeApp} = require("firebase-admin/app");
const {getAuth} = require("firebase-admin/auth");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const {getStorage} = require("firebase-admin/storage");
const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const {verifiedPhoneCandidates} = require("./identity");
initializeApp();

exports.finalizeBuyerPhoneSignIn = onCall({region: "us-central1", maxInstances: 5}, async (request) => {
  let proof;
  try { proof = verifiedPhoneCandidates(request.auth); }
  catch (_) { throw new HttpsError("unauthenticated", "Подтвердите номер телефона с помощью SMS Google."); }
  const db = getFirestore();
  const auth = getAuth();
  const profiles = await db.getAll(...proof.candidates.map(uid => db.collection("users").doc(uid)));
  const existing = profiles.filter(doc => doc.exists);
  if (existing.length > 1) {
    // Never guess which account owns orders when legacy data is ambiguous.
    throw new HttpsError("failed-precondition", "Найдены два профиля номера. Обратитесь в поддержку.");
  }
  const uid = existing[0]?.id || request.auth.uid;
  let user;
  try { user = await auth.getUser(uid); }
  catch (error) {
    if (error.code !== "auth/user-not-found") throw error;
    user = await auth.createUser({uid});
  }
  if (user.disabled) throw new HttpsError("permission-denied", "Аккаунт отключён.");
  const profile = db.collection("users").doc(uid);
  await db.runTransaction(async transaction => {
    const snapshot = await transaction.get(profile);
    if (!snapshot.exists) {
      transaction.create(profile, {uid, phone_number: proof.phone, created_time: FieldValue.serverTimestamp()});
    }
    transaction.set(db.collection("_buyerPhoneIdentities").doc(uid), {
      phoneAuthUid: request.auth.uid,
      verifiedPhone: proof.phone,
      verifiedAt: FieldValue.serverTimestamp(),
    }, {merge: true});
  });
  const token = await auth.createCustomToken(uid, {buyerPhoneVerified: true, verifiedPhone: proof.phone});
  return {token};
});

exports.syncAccountRole = onDocumentWritten({document: "users/{uid}", region: "us-central1", maxInstances: 2}, async (event) => {
  const profile = event.data?.after.data();
  const ref = getFirestore().collection("_accessRoles").doc(event.params.uid);
  const directory = getFirestore().collection("userDirectory").doc(event.params.uid);
  const role = profile?.admin === true ? "admin" :
    profile?.partner === true && profile.role !== "0" ? "seller" : null;
  if (role) await ref.set({role});
  else await ref.delete();
  if (profile) await directory.set({display_name: profile.display_name || "", photo_url: profile.photo_url || ""});
  else await directory.delete();
});

exports.submitSellerApplication = onCall({region: "us-central1", maxInstances: 2}, async (request) => {
  if (!request.auth || request.auth.token.firebase?.sign_in_provider !== "password") {
    throw new HttpsError("unauthenticated", "Войдите по e-mail и паролю.");
  }
  const name = typeof request.data?.displayName === "string" ? request.data.displayName.trim() : "";
  if (!name || name.length > 100) throw new HttpsError("invalid-argument", "Укажите имя.");
  const db = getFirestore();
  await db.runTransaction(async transaction => {
    const ref = db.collection("users").doc(request.auth.uid);
    const roles = await transaction.get(db.collection("_accessRoles").doc(request.auth.uid));
    if (roles.exists) throw new HttpsError("already-exists", "У аккаунта уже есть доступ.");
    transaction.set(ref, {uid: request.auth.uid, email: request.auth.token.email || "", display_name: name, role: "0", partner: true}, {merge: true});
    transaction.set(db.collection("_sellerApplications").doc(request.auth.uid), {submittedAt: FieldValue.serverTimestamp()}, {merge: true});
  });
  return {submitted: true};
});

exports.deleteOwnAccount = onCall({region: "us-central1", maxInstances: 2, timeoutSeconds: 300}, async (request) => {
  const token = request.auth?.token;
  const provider = token?.firebase?.sign_in_provider;
  if (!request.auth || !(provider === "password" || token.buyerPhoneVerified === true)) {
    throw new HttpsError("unauthenticated", "Войдите в аккаунт.");
  }
  if (!Number.isFinite(token.auth_time) || Date.now() / 1000 - token.auth_time > 300) {
    throw new HttpsError("failed-precondition", "Для удаления выйдите и войдите заново.");
  }
  const db = getFirestore();
  const uid = request.auth.uid;
  const profile = db.collection("users").doc(uid);
  const access = db.collection("_accessRoles").doc(uid);
  const role = await access.get();
  if (role.data()?.role === "admin") {
    throw new HttpsError("failed-precondition", "Аккаунт администратора удаляется через поддержку.");
  }
  const identityRef = db.collection("_buyerPhoneIdentities").doc(uid);
  const identity = (await identityRef.get()).data();
  const writer = db.bulkWriter();
  const erase = async (collection, field) => {
    const snapshot = await db.collection(collection).where(field, "==", profile).get();
    snapshot.docs.forEach(document => writer.delete(document.ref));
  };
  await Promise.all([
    erase("cart", "idUsers"), erase("history", "user"),
    erase("chat_messages", "user"), erase("shopSkidki", "idPartner"), erase("tovari", "idPartner"),
  ]);
  for (const collection of ["order", "orderPayment"]) {
    const orders = await db.collection(collection).where("idUser", "==", profile).get();
    for (const order of orders.docs) {
      const update = {idUser: FieldValue.delete(), tel: FieldValue.delete(), adres: FieldValue.delete()};
      if (Array.isArray(order.data().carts)) {
        update.carts = order.data().carts.map(item => {
          const {idUser, ...anonymousItem} = item;
          return anonymousItem;
        });
      }
      writer.update(order.ref, update);
    }
  }
  const chats = await db.collection("chats").where("users", "array-contains", profile).get();
  for (const chat of chats.docs) {
    const update = {
      users: FieldValue.arrayRemove(profile),
      last_message_seen_by: FieldValue.arrayRemove(profile),
    };
    if (chat.data().last_message_sent_by?.path === profile.path) {
      update.last_message = FieldValue.delete();
      update.last_message_sent_by = FieldValue.delete();
    }
    for (const field of ["user_a", "user_b"]) {
      if (chat.data()[field]?.path === profile.path) update[field] = FieldValue.delete();
    }
    writer.update(chat.ref, update);
  }
  writer.delete(profile);
  writer.delete(access);
  writer.delete(db.collection("_sellerApplications").doc(uid));
  writer.delete(db.collection("userDirectory").doc(uid));
  await writer.close();
  await getStorage().bucket().deleteFiles({prefix: `users/${uid}/`});
  if (identity?.phoneAuthUid && identity.phoneAuthUid !== uid) {
    try {
      const phoneAccount = await getAuth().getUser(identity.phoneAuthUid);
      if (phoneAccount.phoneNumber === identity.verifiedPhone) await getAuth().deleteUser(phoneAccount.uid);
    } catch (error) { if (error.code !== "auth/user-not-found") throw error; }
  }
  await identityRef.delete();
  try { await getAuth().deleteUser(uid); }
  catch (error) { if (error.code !== "auth/user-not-found") throw error; }
  return {deleted: true};
});
