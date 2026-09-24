import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/booking.dart';

part 'payment_state.freezed.dart';

@freezed
abstract class PaymentState with _$PaymentState {
  const factory PaymentState({
    @Default(true) bool loading,
    Booking? booking,
    String? qrCode,
    String? errorMessage,
  }) = _PaymentState;
}
