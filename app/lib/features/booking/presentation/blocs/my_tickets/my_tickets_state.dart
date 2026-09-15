import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/booking.dart';

part 'my_tickets_state.freezed.dart';

@freezed
abstract class MyTicketsState with _$MyTicketsState {
  const factory MyTicketsState({
    @Default(true) bool isLoading,
    @Default(<Booking>[]) List<Booking> bookings,
    String? errorMessage,
  }) = _MyTicketsState;
}
