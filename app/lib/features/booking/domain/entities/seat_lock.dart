class SeatLock {
  final String seatCode;
  final String userId;
  final String status; // "selecting" | "sold"
  final int? expiresAt;

  const SeatLock({
    required this.seatCode,
    required this.userId,
    required this.status,
    this.expiresAt,
  });
}
