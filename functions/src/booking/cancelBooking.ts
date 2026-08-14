import { HttpsError, onCall } from "firebase-functions/https";
import { cancelBookingSchema } from "./types";
import { FieldValue, getFirestore, Timestamp } from "firebase-admin/firestore";
import { canCancel } from "./cancelPolicy";

export const cancelBooking = onCall(async (request) => {
  const auth = request.auth;
  if (!auth) {
    throw new HttpsError("unauthenticated", "Bạn cần đăng nhập để hủy vé.");
  }

  const parsed = cancelBookingSchema.safeParse(request.data);
  if (!parsed.success) {
    throw new HttpsError("invalid-argument", "Dữ liệu đầu vào không hợp lệ.");
  }

  const db = getFirestore();
  const bookingRef = db.doc(`bookings/${parsed.data.bookingId}`);

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
    if (verdict !== null) {
      throw new HttpsError("failed-precondition", "Không thể hủy đơn này", {
        code: verdict,
      });
    }

    const eventRef = db.doc(`events/${data?.eventId}`);
    const lineItems = (data?.lineItems ?? []) as Array<{
      ticketTypeId: string;
      quantity: number;
    }>;
    let ticketCount = 0;
    for (const li of lineItems) {
      ticketCount += li.quantity;
    }

    tx.update(bookingRef, {
      status: "canceled",
      canceledAt: Timestamp.now(),
    });
    for (const li of lineItems) {
      tx.update(eventRef.collection("ticketTypes").doc(li.ticketTypeId), {
        sold: FieldValue.increment(-li.quantity),
      });
    }
    tx.update(eventRef, {
      ticketsSold: FieldValue.increment(-ticketCount),
    });
    tx.set(
      eventRef.collection("buyers").doc(auth.uid),
      {
        bookingCount: FieldValue.increment(-1),
        updatedAt: Timestamp.now(),
      },
      { merge: true },
    );
  });

  return { ok: true };
});
