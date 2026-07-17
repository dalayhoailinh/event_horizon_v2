import { getAuth } from "firebase-admin/auth";
import { getFirestore } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";

const ALLOWED_ROLES = ["user", "organizer", "staff", "admin"];

export const setUserRole = onCall(async (request) => {
  if (request.auth?.token.role !== "admin") {
    throw new HttpsError("permission-denied", "Chỉ admin được đổi vai trò.");
  }
  const uid = request.data?.uid as string | undefined;
  const role = request.data?.role as string | undefined;
  if (!uid || !role || !ALLOWED_ROLES.includes(role)) {
    throw new HttpsError("invalid-argument", "Cần uid và role hợp lệ.");
  }

  await getAuth().setCustomUserClaims(uid, { role });
  await getFirestore().collection("users").doc(uid).update({ role });
  return { ok: true };
});
