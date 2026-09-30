import { describe, expect, it } from "vitest";
import { call, db, intent, seedEvent, verifiedUser } from "./helpers";
import { confirmPaidBooking } from "../src/payos/confirmPaidBooking";

const PRICE = 200_000;

async function paidBooking(): Promise<{ bookingId: string; amount: number }> {
  const eventId = await seedEvent({ price: PRICE });
  const user = await verifiedUser();
  const res = await call("createBooking", user.idToken, {
    eventId,
    bookingIntentId: intent(),
    items: [{ ticketTypeId: "t1", quantity: 2 }],
  });
  const bookingId = res.result?.bookingId as string;
  await db
    .collection("bookings")
    .doc(bookingId)
    .update({
      "payment.payosOrderCode": bookingId.slice(-9),
    });
  return { bookingId, amount: PRICE * 2 };
}

describe("confirmPaidBooking (lõi của webhook)", () => {
  it("đủ tiền -> confirm + vé QR ký; gọi lần 2 -> already-done", async () => {
    const { bookingId, amount } = await paidBooking();
    const orderCode = bookingId.slice(-9);

    const first = await confirmPaidBooking({
      db,
      orderCode,
      paidAmount: amount,
      qrSecretValue: "test-secret",
    });
    expect(first).toBe("confirmed");

    const snap = await db.collection("bookings").doc(bookingId).get();
    expect(snap.data()?.status).toBe("confirmed");
    expect(snap.data()?.ticket?.qrSignature).toBeTruthy();

    const second = await confirmPaidBooking({
      db,
      orderCode,
      paidAmount: amount,
      qrSecretValue: "test-secret",
    });
    expect(second).toBe("already-done");
  }, 30_000);

  it("thiếu tiền -> amount-mismatch, đơn vẫn chờ", async () => {
    const { bookingId, amount } = await paidBooking();
    const outcome = await confirmPaidBooking({
      db,
      orderCode: bookingId.slice(-9),
      paidAmount: amount - 1,
      qrSecretValue: "test-secret",
    });
    expect(outcome).toBe("amount-mismatch");
    const snap = await db.collection("bookings").doc(bookingId).get();
    expect(snap.data()?.status).toBe("pendingPayment");
  }, 30_000);

  it("thừa tiền -> vẫn confirm, nhưng log cảnh báo", async () => {
    const { bookingId, amount } = await paidBooking();
    const outcome = await confirmPaidBooking({
      db,
      orderCode: bookingId.slice(-9),
      paidAmount: amount + 1,
      qrSecretValue: "test-secret",
    });
    expect(outcome).toBe("confirmed");
    const snap = await db.collection("bookings").doc(bookingId).get();
    expect(snap.data()?.status).toBe("confirmed");
    expect(snap.data()?.payment?.paidAmount).toBe(amount + 1);
  }, 30_000);
});
