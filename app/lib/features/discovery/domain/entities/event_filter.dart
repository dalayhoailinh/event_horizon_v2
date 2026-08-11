import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_filter.freezed.dart';

enum EventTimeRange { all, today, thisWeek, thisMonth }

@freezed
abstract class EventFilter with _$EventFilter {
  const factory EventFilter({
    String? categoryId,
    String? provinceCode,
    @Default(EventTimeRange.all) EventTimeRange timeRange,
    @Default('') String searchQuery,
  }) = _EventFilter;
}

extension EventFilterSearch on EventFilter {
  EventFilter withSearch(String query) =>
      EventFilter(searchQuery: query.trim());
}
