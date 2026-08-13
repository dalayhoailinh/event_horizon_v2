import { describe, expect, it } from "vitest";
import { planBooking, EventState, TicketTypeState } from "./planBooking";

const NOW = 1_800_000_000_000; // 2027-01-01T00:00:00.000Z

function event(over: Partial<EventState> = {}): EventState {
  return {
    status: "published",
    startAtMs: NOW + 86_400_000, // 1 day later
    maxBookingsPerUser: 4,
    ...over,
  };
}

function tt(over: Partial<TicketTypeState> = {}): TicketTypeState {
  return {
    id: "t1",
    name: "Vé Mời",
    price: 0,
    quantity: 100,
    sold: 0,
    isActive: true,
    ...over,
  };
}

function input(items = [{ ticketTypeId: "t1", quantity: 2 }]) {
  return {
    eventId: "evt",
    bookingIntentId: "abcdefghij1234567890",
    items,
  };
}

function run(
  over: {
    event?: EventState | null;
    tts?: Array<TicketTypeState | null>;
    count?: number;
    items?: Array<{ ticketTypeId: string; quantity: number }>;
  } = {},
) {
  const tts = over.tts ?? [tt()];
  const map = new Map<string, TicketTypeState | null>();
  for (const t of tts) {
    if (t) map.set(t.id, t);
  }
  const items = over.items ?? [{ ticketTypeId: "t1", quantity: 2 }];
  for (const item of items) {
    if (!map.has(item.ticketTypeId)) map.set(item.ticketTypeId, null);
  }
  return planBooking({
    input: input(items),
    event: over.event === undefined ? event() : over.event,
    ticketTypes: map,
    buyerBookingCount: over.count ?? 0,
    nowMs: NOW,
  });
}

function codeOf(result: ReturnType<typeof planBooking>): string {
  return result.ok ? "OK" : result.code;
}

describe("planBooking — các nhánh từ chối", () => {
  it("event không tồn tại", () => {
    expect(codeOf(run({ event: null }))).toBe("event-not-available");
  });

  it("event chưa published", () => {
    expect(codeOf(run({ event: event({ status: "draft" }) }))).toBe(
      "event-not-available",
    );
  });

  it("event đã diễn ra", () => {
    expect(codeOf(run({ event: event({ startAtMs: NOW - 1 }) }))).toBe(
      "event-started",
    );
  });

  it("chạm hạn mức đơn/người (chống săn vé)", () => {
    expect(codeOf(run({ count: 4 }))).toBe("booking-limit");
  });

  it("hạn mức 0 = không giới hạn", () => {
    expect(
      codeOf(
        run({
          event: event({ maxBookingsPerUser: 0 }),
          count: 999,
        }),
      ),
    ).toBe("OK");
  });

  it("loại vé không tồn tại", () => {
    expect(
      codeOf(
        run({
          items: [{ ticketTypeId: "ma", quantity: 1 }],
        }),
      ),
    ).toBe("ticket-type-not-found");
  });

  it("loại vé đã tắt (isActive false)", () => {
    expect(codeOf(run({ tts: [tt({ isActive: false })] }))).toBe(
      "ticket-type-not-found",
    );
  });

  it("vé trả phí bị chặn ở GĐ3", () => {
    expect(codeOf(run({ tts: [tt({ price: 200000 })] }))).toBe(
      "paid-not-supported",
    );
  });

  it("không đủ tồn kho: còn 1 mà mua 2", () => {
    expect(codeOf(run({ tts: [tt({ quantity: 10, sold: 9 })] }))).toBe(
      "sold-out",
    );
  });

  it("loại vé lặp trong đơn", () => {
    expect(
      codeOf(
        run({
          items: [
            { ticketTypeId: "t1", quantity: 1 },
            { ticketTypeId: "t1", quantity: 1 },
          ],
        }),
      ),
    ).toBe("duplicate-ticket-type");
  });

  it("quá 10 vé mỗi đơn (2 loại x 6)", () => {
    const t2 = tt({ id: "t2", name: "Vé mời 2" });
    expect(
      codeOf(
        run({
          tts: [tt(), t2],
          items: [
            { ticketTypeId: "t1", quantity: 6 },
            { ticketTypeId: "t2", quantity: 6 },
          ],
        }),
      ),
    ).toBe("too-many-tickets");
  });
});

describe("planBooking — đơn hợp lệ", () => {
  it("mua đúng số vé cuối cùng: OK, plan đúng số lượng", () => {
    const result = run({ tts: [tt({ quantity: 10, sold: 8 })] });
    expect(result.ok).toBe(true);
    if (result.ok) {
      expect(result.plan.ticketCount).toBe(2);
      expect(result.plan.totalAmount).toBe(0);
      expect(result.plan.lineItems).toHaveLength(1);
    }
  });
});
