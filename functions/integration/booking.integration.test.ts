import { describe, expect, it } from "vitest";
import { call, db, intent, seedEvent, soldOf, verifiedUser } from "./helpers";

describe("createBooking (emulator)", () => {
  it("đặt thành công + retry cùng intent -> không tạo đơn đôi", async () => {
    const eventId = await seedEvent();
    const user = await verifiedUser();
    const data = {
      eventId,
      bookingIntentId: intent(),
      items: [{ ticketTypeId: "t1", quantity: 2 }],
    };

    const first = await call("createBooking", user.idToken, data);
    expect(first.error).toBeUndefined();
    const retry = await call("createBooking", user.idToken, data);
    expect(retry.result?.bookingId).toBe(first.result?.bookingId);
    expect(retry.result?.duplicate).toBe(true);

    expect(await soldOf(eventId)).toBe(2);
  }, 30_000);

  it("2 đơn song song tranh 3 vé cuối -> chỉ 1 đơn thành công", async () => {
    const eventId = await seedEvent({ remaining: 3 });
    const [alice, bob] = await Promise.all([verifiedUser(), verifiedUser()]);
    const dataFor = () => ({
      eventId,
      bookingIntentId: intent(),
      items: [{ ticketTypeId: "t1", quantity: 2 }],
    });

    const [r1, r2] = await Promise.all([
      call("createBooking", alice.idToken, dataFor()),
      call("createBooking", bob.idToken, dataFor()),
    ]);

    const wins = [r1, r2].filter((r) => r.result?.bookingId).length;
    const losses = [r1, r2].filter(
      (r) => r.error?.details?.code === "sold-out",
    ).length;
    expect(wins).toBe(1);
    expect(losses).toBe(1);
    expect(await soldOf(eventId)).toBe(2);
  }, 30_000);

  it("quá hạn mức đơn/người -> booking-limit", async () => {
    const eventId = await seedEvent({ maxBookings: 2 });
    const user = await verifiedUser();
    const book = () =>
      call("createBooking", user.idToken, {
        eventId,
        bookingIntentId: intent(),
        items: [{ ticketTypeId: "t1", quantity: 1 }],
      });

    expect((await book()).error).toBeUndefined();
    expect((await book()).error).toBeUndefined();
    const third = await book();
    expect(third.error?.details?.code).toBe("booking-limit");
  }, 30_000);

  it("vé trả phí -> pendingPayment, chưa có ticket", async () => {
    const eventId = await seedEvent({ price: 200_000 });
    const user = await verifiedUser();
    const res = await call("createBooking", user.idToken, {
      eventId,
      bookingIntentId: intent(),
      items: [{ ticketTypeId: "t1", quantity: 1 }],
    });
    expect(res.error).toBeUndefined();
    const snap = await db.doc(`bookings/${res.result?.bookingId}`).get();
    const data = snap.data();
    expect(data?.status).toBe("pendingPayment");
    expect(data?.ticket).toBeNull();
    expect(data?.expiresAt).toBeTruthy();
  }, 30_000);
});

describe("cancelBooking (emulator)", () => {
  it("hủy -> hoàn kho + hoàn counter -> đặt lại được", async () => {
    const eventId = await seedEvent({ maxBookings: 1 });
    const user = await verifiedUser();
    const first = await call("createBooking", user.idToken, {
      eventId,
      bookingIntentId: intent(),
      items: [{ ticketTypeId: "t1", quantity: 2 }],
    });
    expect(await soldOf(eventId)).toBe(2);

    const cancel = await call("cancelBooking", user.idToken, {
      bookingId: first.result?.bookingId,
    });
    expect(cancel.error).toBeUndefined();
    expect(await soldOf(eventId)).toBe(0);

    const again = await call("createBooking", user.idToken, {
      eventId,
      bookingIntentId: intent(),
      items: [{ ticketTypeId: "t1", quantity: 2 }],
    });
    expect(again.error).toBeUndefined();
    expect(await soldOf(eventId)).toBe(2);
  }, 30_000);

  it("hủy đơn của người khác -> not-owner", async () => {
    const eventId = await seedEvent();
    const [alice, bob] = await Promise.all([verifiedUser(), verifiedUser()]);
    const first = await call("createBooking", alice.idToken, {
      eventId,
      bookingIntentId: intent(),
      items: [{ ticketTypeId: "t1", quantity: 2 }],
    });
    expect(first.error).toBeUndefined();
    const cancel = await call("cancelBooking", bob.idToken, {
      bookingId: first.result?.bookingId,
    });
    expect(cancel.error?.details?.code).toBe("not-owner");
  }, 30_000);
});
