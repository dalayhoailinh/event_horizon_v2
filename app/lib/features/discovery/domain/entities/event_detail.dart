import 'package:freezed_annotation/freezed_annotation.dart';

import 'event_summary.dart';

part 'event_detail.freezed.dart';

@freezed
abstract class EventDetail with _$EventDetail {
  const factory EventDetail({
    required EventSummary summary,
    required DateTime endAt,
    required String venueAddress,
    required String organizerName,
    required String descriptionPlain,
    required List<String> galleryUrls,
    required List<TicketTypeInfo> ticketTypes,
  }) = _EventDetail;
}

@freezed
abstract class TicketTypeInfo with _$TicketTypeInfo {
  const factory TicketTypeInfo({
    required String id,
    required String name,
    required String description,
    required int price,
    required int remaining,
    required bool isActive,
  }) = _TicketTypeInfo;
}
