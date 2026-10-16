import { describe, expect, it } from "vitest";
import { collectSeatCodes, isHoldingSeats, seatNodeFor } from "./seatSync";

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

  it("đơn chờ thanh toán -> trạng thái ghế: selecting", () => {
    expect(seatNodeFor("pendingPayment", "u1", 1_800_000_000_000)).toEqual({
      userId: "u1",
      status: "selecting",
      expiresAt: 1_800_000_000_000,
    });
  });

  it("đơn đã thanh toán -> trạng thái ghế: sold", () => {
    expect(seatNodeFor("confirmed", "u1", null)).toEqual({
      userId: "server",
      status: "sold",
      expiresAt: 0,
    });
  });

  it("đơn chờ trả tiền nhưng thiếu expiresAt -> trạng thái ghế: sold", () => {
    expect(seatNodeFor("pendingPayment", "u1", null).status).toBe("sold");
  });
});
