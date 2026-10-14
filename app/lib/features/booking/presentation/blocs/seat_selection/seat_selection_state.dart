import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../discovery/domain/entities/event_detail.dart';
import '../../../domain/entities/seat_booking.dart';
import '../../../domain/entities/seat_lock.dart';
import '../../../domain/entities/seat_map.dart';

part 'seat_selection_state.freezed.dart';

@freezed
abstract class SeatSelectionState with _$SeatSelectionState {
  const factory SeatSelectionState({
    @Default(false) bool loading,
    EventDetail? detail,
    @Default([]) List<SeatMapFloor> floors,
    @Default({}) Map<String, SeatLock> locks,
    @Default({}) Set<String> selected,
    String? message,
    String? loadError,
    @Default(false) bool proceeding,
    String? bookingId,
    @Default(false) bool paymentRequired,
  }) = _SeatSelectionState;
  const SeatSelectionState._();

  Map<String, int> get _priceByType => {
    for (final type in detail?.ticketTypes ?? const <TicketTypeInfo>[])
      type.id: type.price,
  };

  int get totalAmount => seatsTotalAmount(floors, selected, _priceByType);

  bool get canProceed =>
      selected.isNotEmpty && !proceeding && bookingId == null;
}
