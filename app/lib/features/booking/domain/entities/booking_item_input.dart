class BookingItemInput {
  final String ticketTypeId;
  final int quantity;
  final List<String> seatCodes;

  const BookingItemInput({
    required this.ticketTypeId,
    required this.quantity,
    this.seatCodes = const [],
  });
}
