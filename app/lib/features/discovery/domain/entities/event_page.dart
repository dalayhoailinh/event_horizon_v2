import 'package:freezed_annotation/freezed_annotation.dart';

import 'event_summary.dart';

part 'event_page.freezed.dart';

abstract interface class EventCursor {}

@freezed
abstract class EventPage with _$EventPage {
  const factory EventPage({
    required List<EventSummary> events,
    EventCursor? next,
  }) = _EventPage;
}
