import { describe, expect, it } from "vitest";
import { createBookingSchema } from "./types";

const valid = {
  eventId: "event123",
  bookingIntentId: "abc123def456",
  items: [
    {
      ticketTypeId: "ticket123",
      quantity: 2,
    },
  ],
};

describe("CreateBookingInput", () => {
  it("input hợp leek -> pass", () => {
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

  it("itendId có ký tự lạ (chặn injection vào doc id) -> fail", () => {
    const bad = { ...valid, bookingIntentId: "abc/../../etc" };
    expect(createBookingSchema.safeParse(bad).success).toBe(false);
  });
});
