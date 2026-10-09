import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/result/result.dart';
import '../../../../discovery/domain/repositories/discovery_repository.dart';
import '../../../domain/repositories/booking_repository.dart';
import 'seat_selection_state.dart';

@injectable
class SeatSelectionCubit extends Cubit<SeatSelectionState> {
  final DiscoveryRepository _discovery;
  final BookingRepository _booking;

  SeatSelectionCubit(this._discovery, this._booking)
    : super(const SeatSelectionState());

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
    }
  }
}
