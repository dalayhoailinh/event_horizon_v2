import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_create_state.freezed.dart';

@freezed
abstract class BookingCreateState with _$BookingCreateState {
  const factory BookingCreateState({
    @Default(<String, int>{}) Map<String, int> quantities,
    @Default(false) bool submitting,
    String? bookingId,
    @Default(false) bool paymentRequired,
    String? errorMessage,
  }) = _BookingCreateState;
  const BookingCreateState._();

  int get totalTickets {
    var count = 0;
    for (final quantity in quantities.values) {
      count += quantity;
    }
    return count;
  }

  bool get canSubmit => totalTickets > 0 && !submitting;
}
