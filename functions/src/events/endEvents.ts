import { FieldValue, Firestore, Timestamp } from "firebase-admin/firestore";
import { logger } from "firebase-functions";

const BATCH_SIZE = 50;

export async function endDueEvents(db: Firestore): Promise<number> {
  const due = await db
    .collection("events")
    .where("status", "==", "published")
    .where("endAt", "<=", Timestamp.now())
    .limit(BATCH_SIZE)
    .get();
  let ended = 0;
  for (const doc of due.docs) {
    const flipped = await db.runTransaction(async (tx) => {
      const snap = await tx.get(doc.ref);
      if (snap.data()?.status !== "published") return false;
      tx.update(doc.ref, {
        status: "ended",
        updatedAt: FieldValue.serverTimestamp(),
      });
      return true;
    });
    if (flipped) ended++;
  }
  if (ended > 0) {
    logger.info("endDueEvents ended events", { count: ended });
  }
  return ended;
}
