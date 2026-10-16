export function collectSeatCodes(lineItems: unknown): string[] {
  if (!Array.isArray(lineItems)) return [];
  const codes: string[] = [];
  for (const item of lineItems) {
    const seatCodes: unknown = item?.seatCodes;
    if (!Array.isArray(seatCodes)) continue;
    for (const code of seatCodes) {
      if (typeof code === "string" && code.length > 0) codes.push(code);
    }
  }
  return codes;
}

export function isHoldingSeats(status: string): boolean {
  return (
    status === "pendingPayment" ||
    status === "confirmed" ||
    status === "checkedIn"
  );
}
