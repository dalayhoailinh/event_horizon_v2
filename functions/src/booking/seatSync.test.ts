import { describe, expect, it } from "vitest";
import { collectSeatCodes, isHoldingSeats } from "./seatSync";

describe("seatSync", () => {
  it("gom seatCodes từ nhiều lineItems, bỏ rác", () => {
    expect(
      collectSeatCodes([
        { seatCodes: ["1-A1", "1-A2"] },
        { seatCodes: [] },
        { noSeats: true },
        null,
        { seatCodes: ["1-B1", 7, ""] },
      ]),
    ).toEqual(["1-A1", "1-A2", "1-B1"]);
  });

  it("giữ ghế: pendingPayment/confirmed/checkedIn; nhả: còn lại", () => {
    expect(isHoldingSeats("pendingPayment")).toBe(true);
    expect(isHoldingSeats("confirmed")).toBe(true);
    expect(isHoldingSeats("checkedIn")).toBe(true);
    expect(isHoldingSeats("expired")).toBe(false);
    expect(isHoldingSeats("cancelled")).toBe(false);
  });
});
