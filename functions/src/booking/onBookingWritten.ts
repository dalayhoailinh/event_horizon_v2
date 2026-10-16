import { onDocumentWritten } from "firebase-functions/firestore";
import { collectSeatCodes, isHoldingSeats, seatNodeFor } from "./seatSync";
import { getDatabase } from "firebase-admin/database";
import { Timestamp } from "firebase-admin/firestore";

export const onBookingWritten = onDocumentWritten(
  "bookings/{bookingId}",
  async (event) => {
    const after = event.data?.after.data();
    const before = event.data?.before.data();
    const data = after ?? before;
    if (!data) return;
    const seatCodes = collectSeatCodes(data.lineItems);
    if (seatCodes.length === 0) return;

    const holding = after !== undefined && isHoldingSeats(after.status);
    const updates: Record<string, unknown> = {};
    const node = holding
      ? seatNodeFor(
          after.status,
          after.userId as string,
          (after.expiresAt as Timestamp | undefined)?.toMillis() ?? null,
        )
      : null;
    for (const code of seatCodes) {
      updates[`seatLocks/${data.eventId}/${code}`] = node;
    }
    await getDatabase().ref().update(updates);
  },
);
