import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/booking.dart';

part 'ticket_detail_state.freezed.dart';

@freezed
abstract class TicketDetailState with _$TicketDetailState {
  const factory TicketDetailState({
    @Default(true) bool isLoading,
    Booking? booking,
    @Default(false) bool cancelling,
    String? errorMessage,
  }) = _TicketDetailState;
}
