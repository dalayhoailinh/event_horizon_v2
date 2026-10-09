import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../discovery/domain/entities/event_detail.dart';
import '../../../domain/entities/seat_map.dart';

part 'seat_selection_state.freezed.dart';

@freezed
abstract class SeatSelectionState with _$SeatSelectionState {
  const factory SeatSelectionState({
    @Default(false) bool loading,
    EventDetail? detail,
    @Default([]) List<SeatMapFloor> floors,
    String? loadError,
  }) = _SeatSelectionState;
}
