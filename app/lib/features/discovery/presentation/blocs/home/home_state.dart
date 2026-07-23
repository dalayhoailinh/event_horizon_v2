import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/result/failure.dart';
import '../../../domain/entities/event_category.dart';
import '../../../domain/entities/event_summary.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(true) bool isLoading,
    @Default([]) List<EventSummary> featured,
    @Default([]) List<EventSummary> upcoming,
    @Default([]) List<EventCategory> categories,
    Failure? failure,
  }) = _HomeState;
}
