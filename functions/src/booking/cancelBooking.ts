import { HttpsError, onCall } from "firebase-functions/https";
import { cancelBookingSchema } from "./types";
import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { canCancel } from "./cancelPolicy";
import { releaseBooking } from "./release";

export const cancelBooking = onCall(async (request) => {
  const auth = request.auth;
  if (!auth) {
    throw new HttpsError("unauthenticated", "Bạn cần đăng nhập để hủy vé.");
  }
  const parsed = cancelBookingSchema.safeParse(request.data);
  if (!parsed.success) {
    throw new HttpsError("invalid-argument", "Dữ liệu hủy vé không hợp lệ.");
  }

  const db = getFirestore();
  const bookingRef = db.collection("bookings").doc(parsed.data.bookingId);

  await db.runTransaction(async (tx) => {
    const bookingSnap = await tx.get(bookingRef);
    const data = bookingSnap.data();
    const verdict = canCancel({
      booking: data
        ? {
            userId: data.userId as string,
            status: data.status as string,
            eventStartAtMs: (
              data.eventSnapshot.startAt as Timestamp
            ).toMillis(),
          }
        : null,
      uid: auth.uid,
      nowMs: Date.now(),
    });
    if (!data || verdict !== null) {
      throw new HttpsError("failed-precondition", "Bạn không thể hủy vé.", {
        code: verdict ?? "booking-not-found",
      });
    }

    releaseBooking({
      tx,
      db,
      bookingRef,
      data,
      toStatus: "cancelled",
    });
  });

  return { ok: true };
});
