"use strict";
const {test} = require("node:test");
const assert = require("node:assert/strict");
const {verifiedPhoneCandidates} = require("./identity");
const valid = () => ({uid: "phone-proof", token: {phone_number: "+77011234567", auth_time: 1000, firebase: {sign_in_provider: "phone"}}});

test("only a recent Google phone proof resolves the exact legacy UID", () => {
  assert.deepEqual(verifiedPhoneCandidates(valid(), 1100), {phone: "+77011234567", candidates: ["+7 (701) 123-45-67", "+77011234567"]});
});
test("rejects unauthenticated callers and custom tokens from the old endpoint", () => {
  assert.throws(() => verifiedPhoneCandidates(null, 1100));
  const proof = valid(); proof.token.firebase.sign_in_provider = "custom";
  assert.throws(() => verifiedPhoneCandidates(proof, 1100), /phone-auth-required/);
});
test("rejects stale or fabricated phone proofs", () => {
  assert.throws(() => verifiedPhoneCandidates(valid(), 1401), /recent-auth-required/);
  const proof = valid(); proof.token.phone_number = "another-user-uid";
  assert.throws(() => verifiedPhoneCandidates(proof, 1100), /invalid-phone/);
  proof.token.auth_time = undefined;
  assert.throws(() => verifiedPhoneCandidates(proof, 1100), /recent-auth-required/);
});
