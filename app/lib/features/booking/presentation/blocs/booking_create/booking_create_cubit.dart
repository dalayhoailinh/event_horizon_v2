import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/result/result.dart';
import '../../../../../core/util/id_generator.dart';
import '../../../domain/repositories/booking_repository.dart';
import 'booking_create_state.dart';

@injectable
class BookingCreateCubit extends Cubit<BookingCreateState> {
  final BookingRepository _repo;
  late final String _intentId = generateIntentId();

  BookingCreateCubit(this._repo) : super(const BookingCreateState());

  void setQuantity(String ticketTypeId, int quantity) {
    final next = Map<String, int>.from(state.quantities);
    if (quantity <= 0) {
      next.remove(ticketTypeId);
    } else {
      next[ticketTypeId] = quantity;
    }
    emit(state.copyWith(quantities: next, errorMessage: null));
  }

  Future<void> submit(String eventId) async {
    if (!state.canSubmit) return;
    emit(state.copyWith(submitting: true, errorMessage: null));

    final result = await _repo.createBooking(
      eventId: eventId,
      bookingIntentId: _intentId,
      quantities: state.quantities,
    );
    if (isClosed) return;

    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(submitting: false, bookingId: value));
      case Err(:final failure):
        emit(state.copyWith(submitting: false, errorMessage: failure.message));
    }
  }
}
