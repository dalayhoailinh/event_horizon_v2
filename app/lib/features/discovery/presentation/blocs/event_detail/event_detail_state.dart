import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/result/failure.dart';
import '../../../domain/entities/event_detail.dart';

part 'event_detail_state.freezed.dart';

@freezed
abstract class EventDetailState with _$EventDetailState {
  const factory EventDetailState({
    @Default(false) bool isLoading,
    EventDetail? detail,
    Failure? failure,
  }) = _EventDetailState;
}
