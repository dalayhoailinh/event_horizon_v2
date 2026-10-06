import {
  DocumentData,
  DocumentReference,
  FieldValue,
  Firestore,
  Timestamp,
  Transaction,
} from "firebase-admin/firestore";

export function releaseBooking(args: {
  tx: Transaction;
  db: Firestore;
  bookingRef: DocumentReference;
  data: DocumentData;
  toStatus: "cancelled" | "expired";
}): void {
  const { tx, db, bookingRef, data, toStatus } = args;
  const eventRef = db.collection("events").doc(data.eventId as string);
  const lineItems = (data.lineItems ?? []) as Array<{
    ticketTypeId: string;
    quantity: number;
  }>;
  let ticketCount = 0;
  for (const li of lineItems) {
    ticketCount += li.quantity;
  }
  const now = Timestamp.now();
  const stamp =
    toStatus === "cancelled" ? { cancelledAt: now } : { expiredAt: now };

  tx.update(bookingRef, { status: toStatus, ...stamp });
  for (const li of lineItems) {
    tx.update(eventRef.collection("ticketTypes").doc(li.ticketTypeId), {
      sold: FieldValue.increment(-li.quantity),
    });
  }
  tx.update(eventRef, { ticketsSold: FieldValue.increment(-ticketCount) });
  tx.set(
    eventRef.collection("buyers").doc(data.userId as string),
    { bookingCount: FieldValue.increment(-1), updatedAt: now },
    { merge: true },
  );
}
