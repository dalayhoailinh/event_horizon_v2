import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/booking.dart';
import '../../../domain/repositories/booking_repository.dart';
import 'my_tickets_state.dart';

@injectable
class MyTicketsCubit extends Cubit<MyTicketsState> {
  final BookingRepository _repo;
  StreamSubscription<List<Booking>>? _sub;

  MyTicketsCubit(this._repo) : super(const MyTicketsState());

  void start() {
    _sub?.cancel();
    _sub = _repo.watchMyBookings().listen(
      (booking) {
        if (isClosed) return;
        emit(
          state.copyWith(
            isLoading: false,
            bookings: booking,
            errorMessage: null,
          ),
        );
      },
      onError: (error) {
        if (isClosed) return;
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Không tải được danh sách vé.',
          ),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
