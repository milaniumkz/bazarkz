"use strict";

function verifiedPhoneCandidates(auth, nowSeconds = Date.now() / 1000) {
  const token = auth?.token;
  if (!auth?.uid || token?.firebase?.sign_in_provider !== "phone") {
    throw new Error("phone-auth-required");
  }
  if (!Number.isFinite(token.auth_time) || nowSeconds - token.auth_time > 300 || token.auth_time > nowSeconds + 30) {
    throw new Error("recent-auth-required");
  }
  const phone = token.phone_number;
  if (typeof phone !== "string" || !/^\+7\d{10}$/.test(phone)) {
    throw new Error("invalid-phone");
  }
  // Legacy buyer UIDs were the masked phone input, not a random Firebase UID.
  const legacy = `${phone.slice(0, 2)} (${phone.slice(2, 5)}) ${phone.slice(5, 8)}-${phone.slice(8, 10)}-${phone.slice(10)}`;
  return {phone, candidates: [legacy, phone]};
}

module.exports = {verifiedPhoneCandidates};
