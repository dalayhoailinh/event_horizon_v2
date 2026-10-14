import { CreateBookingInput } from "./types";

export type EventState = {
  status: string;
  startAtMs: number;
  maxBookingsPerUser: number; // 0 = unlimited
};

export type TicketTypeState = {
  id: string;
  name: string;
  price: number;
  quantity: number;
  sold: number;
  isActive: boolean;
  seatCodes: string[] | null;
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
  paymentRequired: boolean;
  allSeatCodes: string[];
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
  soldSeatCodes: Set<string>;
  nowMs: number;
}): PlanResult {
  const { input, event, ticketTypes, buyerBookingCount, soldSeatCodes, nowMs } =
    args;

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
    event.maxBookingsPerUser > 0 &&
    buyerBookingCount >= event.maxBookingsPerUser
  ) {
    return err(
      "booking-limit",
      `Bạn đã đạt giới hạn ${event.maxBookingsPerUser} đơn cho sự kiện này.`,
    );
  }

  const seen = new Set<string>();
  const claimedSeats = new Set<string>();
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
      return err("ticket-type-not-found", "Loại vé không tồn tại.");
    }
    if (tt.quantity - tt.sold < item.quantity) {
      return err("sold-out", `"${tt.name}" không còn đủ vé.`);
    }

    const requestedSeats = item.seatCodes ?? [];
    const typeSeats = tt.seatCodes;
    if (typeSeats === null && requestedSeats.length > 0) {
      return err("seats-not-allowed", "Loại vé này không chọn ghế.");
    }
    if (typeSeats !== null) {
      if (requestedSeats.length !== item.quantity) {
        return err("seat-count-mismatch", "Số ghế chọn phải bằng số vé.");
      }
      for (const code of requestedSeats) {
        if (!typeSeats.includes(code)) {
          return err(
            "seat-not-in-type",
            `Ghế "${code}" không thuộc loại vé "${tt.name}".`,
          );
        }
        if (soldSeatCodes.has(code) || claimedSeats.has(code)) {
          return err("seat-taken", `Ghế "${code}" đã có người đặt.`);
        }
        claimedSeats.add(code);
      }
    }

    ticketCount += item.quantity;
    totalAmount += tt.price * item.quantity;
    lineItems.push({
      ticketTypeId: tt.id,
      name: tt.name,
      price: tt.price,
      quantity: item.quantity,
      seatCodes: requestedSeats,
    });
  }

  if (ticketCount > MAX_TICKETS_PER_BOOKING) {
    return err(
      "too-many-tickets",
      `Tối đa ${MAX_TICKETS_PER_BOOKING} vé mỗi đơn.`,
    );
  }

  return {
    ok: true,
    plan: {
      lineItems,
      totalAmount,
      ticketCount,
      paymentRequired: totalAmount > 0,
      allSeatCodes: [...claimedSeats],
    },
  };
}
