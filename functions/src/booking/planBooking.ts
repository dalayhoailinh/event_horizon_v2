import { CreateBookingInput } from "./types";

export type EventState = {
  status: string;
  startAtMs: number;
  maxBookingPerUser: number; // 0 = unlimited
};

export type TicketTypeState = {
  id: string;
  name: string;
  price: number;
  quantity: number;
  sold: number;
  isActive: boolean;
};

export type BookingPlan = {
  lineItems: Array<{
    ticketTypeId: string;
    name: string;
    price: number;
    quantity: number;
    seatCodes: string[];
  }>;
  totalAmount: number;
  ticketCount: number;
};

export const MAX_TICKETS_PER_BOOKING = 10;

export type PlanResult =
  | { ok: true; plan: BookingPlan }
  | { ok: false; code: string; message: string };

function err(code: string, message: string): PlanResult {
  return { ok: false, code, message };
}

export function planBooking(args: {
  input: CreateBookingInput;
  event: EventState | null;
  ticketTypes: Map<string, TicketTypeState | null>;
  buyerBookingCount: number;
  nowMs: number;
}): PlanResult {
  const { input, event, ticketTypes, buyerBookingCount, nowMs } = args;

  if (!event || event.status !== "published") {
    return err(
      "event-not-available",
      "Sự kiện không tồn tại hoặc chưa mở bán.",
    );
  }
  if (event.startAtMs <= nowMs) {
    return err("event-started", "Sự kiện đã diễn ra, không thể đặt vé.");
  }
  if (
    event.maxBookingPerUser > 0 &&
    buyerBookingCount >= event.maxBookingPerUser
  ) {
    return err(
      "booking-limit",
      `Bạn đã đạt giới hạn ${event.maxBookingPerUser} đơn cho sự kiện này.`,
    );
  }

  const seen = new Set<string>();
  const lineItems: BookingPlan["lineItems"] = [];
  let ticketCount = 0;
  let totalAmount = 0;

  for (const item of input.items) {
    if (seen.has(item.ticketTypeId)) {
      return err("duplicate-ticket-type", "Loại vé bị trùng lặp trong đơn.");
    }
    seen.add(item.ticketTypeId);

    const tt = ticketTypes.get(item.ticketTypeId) ?? null;
    if (!tt || !tt.isActive) {
      return err("ticket-type-not-found", "LOại vé không tồn tại.");
    }
    if (tt.price > 0) {
      return err(
        "paid-not-supported",
        "Vé trả phí sẽ mở khi có thanh toán (GĐ4).",
      );
    }
    if (tt.quantity - tt.sold < item.quantity) {
      return err("sold-out", `"${tt.name}" không còn đủ vé.`);
    }

    ticketCount += item.quantity;
    totalAmount += tt.price * item.quantity;
    lineItems.push({
      ticketTypeId: tt.id,
      name: tt.name,
      price: tt.price,
      quantity: item.quantity,
      seatCodes: [],
    });
  }

  if (ticketCount > MAX_TICKETS_PER_BOOKING) {
    return err(
      "too-many-tickets",
      `Tối đa ${MAX_TICKETS_PER_BOOKING} vé mỗi đơn.`,
    );
  }

  return { ok: true, plan: { lineItems, totalAmount, ticketCount } };
}
