import { onDocumentWritten } from "firebase-functions/firestore";
import { collectSeatCodes, isHoldingSeats } from "./seatSync";
import { getDatabase } from "firebase-admin/database";

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
    for (const code of seatCodes) {
      updates[`seatLocks/${data.eventId}/${code}`] = holding
        ? { userId: "server", status: "sold", expiresAt: 0 }
        : null;
    }
    await getDatabase().ref().update(updates);
  },
);
