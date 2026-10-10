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

  bool get isSold => status == 'sold';

  bool isExpired(DateTime now) {
    final expiresAt = this.expiresAt;
    if (expiresAt == null) return false;
    return now.millisecondsSinceEpoch > expiresAt;
  }
}
