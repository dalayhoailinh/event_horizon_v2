import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_summary.freezed.dart';

@freezed
abstract class EventSummary with _$EventSummary {
  const factory EventSummary({
    required String id,
    required String title,
    required String coverImageUrl,
    required DateTime startAt,
    required String venueName,
    required String provinceCode,
    required List<String> categoryNames,
    required int minPrice,
    required int maxPrice,
    required int ticketsSold,
    required int favoriteCount,
    required bool hasSeatMap,
  }) = _EventSummary;
}
