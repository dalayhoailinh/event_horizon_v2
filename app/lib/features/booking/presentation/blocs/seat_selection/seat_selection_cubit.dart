import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/result/result.dart';
import '../../../../discovery/domain/repositories/discovery_repository.dart';
import '../../../domain/entities/seat_lock.dart';
import '../../../domain/entities/seat_map.dart';
import '../../../domain/repositories/booking_repository.dart';
import '../../../domain/repositories/seat_lock_repository.dart';
import 'seat_selection_state.dart';

@injectable
class SeatSelectionCubit extends Cubit<SeatSelectionState> {
  final DiscoveryRepository _discovery;
  final BookingRepository _booking;
  final SeatLockRepository _seatLocks;

  StreamSubscription<Map<String, SeatLock>>? _locksSub;
  final String _eventId = '';

  SeatSelectionCubit(this._discovery, this._booking, this._seatLocks)
    : super(const SeatSelectionState());

  static const int maxSeatsPerBooking = 10;

  Future<void> start(String eventId) async {
    final detailFuture = _discovery.eventDetail(eventId);
    final floorsFuture = _booking.fetchSeatMap(eventId);
    final detail = await detailFuture;
    final floors = await floorsFuture;
    if (isClosed) return;

    switch ((detail, floors)) {
      case (Err(:final failure), _) || (_, Err(:final failure)):
        emit(state.copyWith(loading: false, loadError: failure.message));
      case (Ok(value: final detail), Ok(value: final floors)):
        emit(state.copyWith(loading: false, detail: detail, floors: floors));
        _locksSub = _seatLocks
            .watchLocks(eventId)
            .listen(
              (locks) => emit(state.copyWith(locks: locks)),
              onError: (Object _) => emit(
                state.copyWith(loadError: 'Không đọc được trạng thái ghế.'),
              ),
            );
    }
  }

  Future<void> toggle(SeatCell cell) async {
    if (!cell.isSeat) return;
    final code = cell.code;

    if (state.selected.contains(code)) {
      emit(
        state.copyWith(
          selected: {...state.selected}..remove(code),
          message: null,
        ),
      );
      await _seatLocks.unlockSeat(_eventId, code);
      return;
    }
    if (state.selected.length >= maxSeatsPerBooking) {
      emit(state.copyWith(message: 'Tối đa $maxSeatsPerBooking ghế mỗi đơn.'));
      return;
    }

    final result = await _seatLocks.lockSeat(_eventId, code);
    if (isClosed) return;
    switch (result) {
      case Ok():
        emit(
          state.copyWith(selected: {...state.selected, code}, message: null),
        );
      case Err(:final failure):
        emit(state.copyWith(message: failure.message));
    }
  }

  @override
  Future<void> close() {
    _locksSub?.cancel();
    return super.close();
  }
}
