import { Firestore, Timestamp } from "firebase-admin/firestore";
import { logger } from "firebase-functions";
import { buildQrData, signQr } from "../booking/qr";

export type ConfirmOutcome =
  "confirmed" | "not-found" | "already-done" | "amount-mismatch";

export async function confirmPaidBooking(args: {
  db: Firestore;
  orderCode: string;
  paidAmount: number;
  qrSecretValue: string;
}): Promise<ConfirmOutcome> {
  const { db, orderCode, paidAmount, qrSecretValue } = args;
  const found = await db
    .collection("bookings")
    .where("payment.payosOrderCode", "==", orderCode)
    .limit(1)
    .get();
  if (found.empty) {
    logger.warn("Webhook: no booking for orderCode", { orderCode });
    return "not-found";
  }
  const bookingRef = found.docs[0].ref;

  return await db.runTransaction(async (tx): Promise<ConfirmOutcome> => {
    const snap = await tx.get(bookingRef);
    const data = snap.data();
    if (!data || data.status !== "pendingPayment") {
      return "already-done";
    }
    const expected = data.totalAmount as number;
    if (paidAmount < expected) {
      logger.error("Webhook amount mismatch", {
        orderCode,
        paidAmount,
        expectedAmount: expected,
      });
      return "amount-mismatch";
    }
    if (paidAmount > expected) {
      logger.warn("Webhook amount mismatch (overpaid)", {
        orderCode,
        paidAmount,
        expectedAmount: expected,
        surplus: paidAmount - expected,
      });
    }

    const now = Timestamp.now();
    const qrData = buildQrData(
      bookingRef.id,
      data.eventId as string,
      now.toMillis(),
    );
    tx.update(bookingRef, {
      status: "confirmed",
      confirmedAt: now,
      "payment.paidAmount": paidAmount,
      "payment.status": "paid",
      "payment.paidAt": now,
      ticket: {
        qrData,
        qrSignature: signQr(qrData, qrSecretValue),
        issuedAt: now,
      },
    });
    return "confirmed";
  });
}
