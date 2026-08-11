import '../../../../core/router/route_names.dart';
import '../../domain/entities/event_filter.dart';

const String _qCategory = 'category';
const String _qProvince = 'province';
const String _qSearch = 'search';
const String _qTime = 'time';

const Map<EventTimeRange, String> _timeNames = {
  EventTimeRange.today: 'today',
  EventTimeRange.thisWeek: 'week',
  EventTimeRange.thisMonth: 'month',
};

EventFilter filterFromQuery(Map<String, String> query) {
  return EventFilter(
    categoryId: _nullIfEmpty(query[_qCategory]),
    provinceCode: _nullIfEmpty(query[_qProvince]),
    searchQuery: _nullIfEmpty(query[_qSearch]) ?? '',
    timeRange: _timeFromName(query[_qTime]),
  );
}

Map<String, String> queryFromFilter(EventFilter filter) {
  return {
    _qCategory: ?filter.categoryId,
    _qProvince: ?filter.provinceCode,
    if (filter.searchQuery.isNotEmpty) _qSearch: filter.searchQuery,
    _qTime: ?_timeNames[filter.timeRange],
  };
}

String eventsLocationFor(EventFilter filter) {
  final query = queryFromFilter(filter);
  if (query.isEmpty) return RouteNames.events;
  return Uri(path: RouteNames.events, queryParameters: query).toString();
}

String? _nullIfEmpty(String? value) {
  if (value == null || value.isEmpty) return null;
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return trimmed;
}

EventTimeRange _timeFromName(String? name) {
  if (name == null) return EventTimeRange.all;
  for (final entry in _timeNames.entries) {
    if (entry.value == name) return entry.key;
  }
  return EventTimeRange.all;
}
