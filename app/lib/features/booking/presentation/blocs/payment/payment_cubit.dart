import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/result/result.dart';
import '../../../domain/entities/booking.dart';
import '../../../domain/repositories/booking_repository.dart';
import 'payment_state.dart';

@injectable
class PaymentCubit extends Cubit<PaymentState> {
  final BookingRepository _repo;
  StreamSubscription<Booking?>? _sub;

  PaymentCubit(this._repo) : super(const PaymentState());

  Future<void> start(String bookingId) async {
    await _sub?.cancel();
    _sub = _repo
        .watchBooking(bookingId)
        .listen(
          (booking) => emit(state.copyWith(loading: false, booking: booking)),
          onError: (Object _) => emit(
            state.copyWith(
              loading: false,
              errorMessage: 'Không tìm thấy đơn này.',
            ),
          ),
        );
    final result = await _repo.createPayosOrder(bookingId);
    if (isClosed) return;
    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(qrCode: value));
      case Err(:final failure):
        emit(state.copyWith(errorMessage: failure.message));
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
