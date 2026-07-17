import { FieldValue, getFirestore } from "firebase-admin/firestore";
import * as functionsV1 from "firebase-functions/v1";

import { buildNewUserDoc } from "./newUserDoc";

export const onUserCreated = functionsV1
  .region("asia-southeast1")
  .auth.user()
  .onCreate(async (user) => {
    const doc = buildNewUserDoc({
      uid: user.uid,
      email: user.email ?? "",
      displayName: user.displayName ?? "",
    });
    await getFirestore()
      .collection("users")
      .doc(user.uid)
      .set({
        ...doc,
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });
  });
