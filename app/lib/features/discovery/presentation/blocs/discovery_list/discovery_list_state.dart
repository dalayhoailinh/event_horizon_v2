import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/result/failure.dart';
import '../../../domain/entities/event_category.dart';
import '../../../domain/entities/event_filter.dart';
import '../../../domain/entities/event_page.dart';
import '../../../domain/entities/event_summary.dart';

part 'discovery_list_state.freezed.dart';

@freezed
abstract class DiscoveryListState with _$DiscoveryListState {
  const factory DiscoveryListState({
    @Default(EventFilter()) EventFilter filter,
    @Default([]) List<EventSummary> events,
    @Default([]) List<EventCategory> categories,
    @Default(true) bool isLoading,
    @Default(false) bool isLoadingMore,
    Failure? failure,
    EventCursor? cursor,
  }) = _DiscoveryListState;
  const DiscoveryListState._();

  bool get hasMore => cursor != null;
}
