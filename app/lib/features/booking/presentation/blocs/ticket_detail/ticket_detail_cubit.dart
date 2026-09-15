import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/result/result.dart';
import '../../../domain/entities/booking.dart';
import '../../../domain/repositories/booking_repository.dart';
import '../ticket_detail/ticket_detail_state.dart';

@injectable
class TicketDetailCubit extends Cubit<TicketDetailState> {
  final BookingRepository _repo;
  StreamSubscription<Booking?>? _sub;

  TicketDetailCubit(this._repo) : super(const TicketDetailState());

  void start(String bookingId) {
    _sub?.cancel();
    _sub = _repo.watchBooking(bookingId).listen((booking) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, booking: booking));
    });
  }

  Future<void> cancel(String bookingId) async {
    if (state.cancelling) return;
    emit(state.copyWith(cancelling: true, errorMessage: null));
    final result = await _repo.cancelBooking(bookingId);
    if (isClosed) return;
    switch (result) {
      case Ok():
        emit(state.copyWith(cancelling: false));
      case Err(:final failure):
        emit(state.copyWith(cancelling: false, errorMessage: failure.message));
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
