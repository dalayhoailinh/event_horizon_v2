import { Firestore, getFirestore, Timestamp } from "firebase-admin/firestore";
import { releaseBooking } from "./release";
import { logger } from "firebase-functions";
import { onSchedule } from "firebase-functions/scheduler";
import { endDueEvents } from "../events/endEvents";

const BATCH_SIZE = 50;

export async function expireDueBookings(db: Firestore): Promise<number> {
  const due = await db
    .collection("bookings")
    .where("status", "==", "pendingPayment")
    .where("expiresAt", "<=", Timestamp.now())
    .limit(BATCH_SIZE)
    .get();
  let released = 0;
  for (const doc of due.docs) {
    const done = await db.runTransaction(async (tx) => {
      const snap = await tx.get(doc.ref);
      const data = snap.data();
      if (!data || data.status !== "pendingPayment") return false;
      releaseBooking({
        tx,
        db,
        bookingRef: doc.ref,
        data,
        toStatus: "expired",
      });
      return true;
    });
    if (done) released++;
  }
  if (released > 0) {
    logger.info("expireDueBookings released bookings", { count: released });
  }
  return released;
}

export const expireBookings = onSchedule("every 1 minutes", async () => {
  const db = getFirestore();
  await expireDueBookings(getFirestore());
  await endDueEvents(db);
});
