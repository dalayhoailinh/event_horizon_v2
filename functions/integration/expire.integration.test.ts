import { describe, expect, it } from "vitest";
import { call, db, intent, seedEvent, soldOf, verifiedUser } from "./helpers";
import { expireDueBookings } from "../src/booking/expireBookings";

describe("expireDueBookings", () => {
  it("đơn quá hạn: hoàn kho + hoàn counter -> đặt lại được", async () => {
    const eventId = await seedEvent({ price: 200_000, maxBookings: 1 });
    const user = await verifiedUser();
    const first = await call("createBooking", user.idToken, {
      eventId,
      bookingIntentId: intent(),
      items: [{ ticketTypeId: "t1", quantity: 2 }],
    });
    expect(first.error).toBeUndefined();
    expect(await soldOf(eventId)).toBe(2);

    const bookingRef = db
      .collection("bookings")
      .doc(first.result?.bookingId as string);
    await bookingRef.update({
      expiresAt: new Date(Date.now() - 1000),
    });
    await expireDueBookings(db);

    expect((await bookingRef.get()).data()?.status).toBe("expired");
    expect(await soldOf(eventId)).toBe(0);

    const again = await call("createBooking", user.idToken, {
      eventId,
      bookingIntentId: intent(),
      items: [{ ticketTypeId: "t1", quantity: 2 }],
    });
    expect(again.error).toBeUndefined();
    expect(await soldOf(eventId)).toBe(2);
  }, 30_000);
});
