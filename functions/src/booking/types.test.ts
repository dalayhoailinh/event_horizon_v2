import { describe, expect, it } from "vitest";
import { createBookingSchema } from "./types";

const valid = {
  eventId: "evt007",
  bookingIntentId: "abcdefghij1234567890",
  items: [{ ticketTypeId: "t1", quantity: 2 }],
};

describe("createBookingSchema", () => {
  it("input hợp lệ -> pass", () => {
    expect(createBookingSchema.safeParse(valid).success).toBe(true);
  });

  it("quantity 0 hoặc âm -> fail", () => {
    const bad = { ...valid, items: [{ ticketTypeId: "t1", quantity: 0 }] };
    expect(createBookingSchema.safeParse(bad).success).toBe(false);
  });

  it("item rỗng -> fail", () => {
    expect(createBookingSchema.safeParse({ ...valid, items: [] }).success).toBe(
      false,
    );
  });

  it("intendId có ký tự lạ (chặn injection vào doc id) -> fail", () => {
    const bad = { ...valid, bookingIntentId: "abc/../../etc" };
    expect(createBookingSchema.safeParse(bad).success).toBe(false);
  });
});
