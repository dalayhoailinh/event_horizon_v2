import { describe, expect, it } from "vitest";
import { canCancel } from "./cancelPolicy";

const NOW = 1_800_000_000_000; // 2027-12-14T22:40:00.000Z

function booking(
  over: Partial<Parameters<typeof canCancel>[0]["booking"] & object> = {},
) {
  return {
    userId: "u1",
    status: "confirmed",
    eventStartAtMs: NOW + 3_600_000,
    ...over,
  };
}

describe("canCancel", () => {
  it("chủ đơn + confirmed + trước giờ diễn ra -> null (được hủy)", () => {
    expect(canCancel({ booking: booking(), uid: "u1", nowMs: NOW })).toBeNull();
  });

  it("không phải chủ đơn", () => {
    expect(canCancel({ booking: booking(), uid: "u2", nowMs: NOW })).toBe(
      "not-owner",
    );
  });

  it("đơn đã hủy rồi -> not-cancellable (không hủy 2 lần)", () => {
    expect(
      canCancel({
        booking: booking({ status: "cancelled" }),
        uid: "u1",
        nowMs: NOW,
      }),
    ).toBe("not-cancellable");
  });

  it("sự kiện đã bắt đầu", () => {
    expect(
      canCancel({
        booking: booking({ eventStartAtMs: NOW - 1 }),
        uid: "u1",
        nowMs: NOW,
      }),
    ).toBe("event-started");
  });

  it("đơn không tồn tại", () => {
    expect(canCancel({ booking: null, uid: "u1", nowMs: NOW })).toBe(
      "booking-not-found",
    );
  });
});
