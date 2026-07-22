import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/event_category.dart';
import '../../domain/entities/event_detail.dart';
import '../../domain/entities/event_summary.dart';

EventSummary mapEventSummary(String id, Map<String, dynamic> data) {
  final venue = (data['venue'] as Map<String, dynamic>?) ?? const {};
  return EventSummary(
    id: id,
    title: (data['title'] as String?) ?? '',
    coverImageUrl: (data['coverImageUrl'] as String?) ?? '',
    startAt: (data['startAt'] as Timestamp).toDate(),
    venueName: (venue['name'] as String?) ?? '',
    provinceCode: (venue['provinceCode'] as String?) ?? '',
    categoryNames: List<String>.from(
      (data['categoryNames'] as List?) ?? const [],
    ),
    minPrice: (data['minPrice'] as num?)?.toInt() ?? 0,
    maxPrice: (data['maxPrice'] as num?)?.toInt() ?? 0,
    ticketsSold: (data['ticketsSold'] as num?)?.toInt() ?? 0,
    favoriteCount: (data['favoriteCount'] as num?)?.toInt() ?? 0,
    hasSeatMap: (data['hasSeatMap'] as bool?) ?? false,
  );
}

TicketTypeInfo mapTicketTypeInfo(String id, Map<String, dynamic> data) {
  final quantity = (data['quantity'] as num?)?.toInt() ?? 0;
  final sold = (data['sold'] as num?)?.toInt() ?? 0;
  return TicketTypeInfo(
    id: id,
    name: (data['name'] as String?) ?? '',
    description: (data['description'] as String?) ?? '',
    price: (data['price'] as num?)?.toInt() ?? 0,
    remaining: quantity - sold,
    isActive: (data['isActive'] as bool?) ?? false,
  );
}

EventCategory mapCategory(String id, Map<String, dynamic> data) {
  return EventCategory(id: id, name: (data['name'] as String?) ?? '');
}

EventDetail mapEventDetail({
  required String id,
  required Map<String, dynamic> event,
  required Map<String, dynamic>? content,
  required List<TicketTypeInfo> ticketTypes,
}) {
  final venue = (event['venue'] as Map<String, dynamic>?) ?? const {};
  return EventDetail(
    summary: mapEventSummary(id, event),
    endAt: (event['endAt'] as Timestamp).toDate(),
    venueAddress: (venue['address'] as String?) ?? '',
    organizerName: (event['organizerName'] as String?) ?? '',
    descriptionPlain: (content?['descriptionPlain'] as String?) ?? '',
    galleryUrls: List<String>.from(
      (content?['galleryUrls'] as List?) ?? const [],
    ),
    ticketTypes: ticketTypes,
  );
}
