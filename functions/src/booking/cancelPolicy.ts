export type CancellableBooking = {
  userId: string;
  status: string;
  eventStartAtMs: number;
};

export function canCancel(args: {
  booking: CancellableBooking | null;
  uid: string;
  nowMs: number;
}): string | null {
  const { booking, uid, nowMs } = args;
  if (!booking) return "booking-not-found";
  if (booking.userId !== uid) return "not-owner";
  if (booking.status !== "confirmed") return "not-cancellable";
  if (booking.eventStartAtMs <= nowMs) return "event-started";
  return null;
}
