import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/firebase/firestore_error_mapper.dart';
import '../../../../core/result/app_exception.dart';
import '../../../../core/text/search_text.dart';
import '../../domain/entities/event_category.dart';
import '../../domain/entities/event_detail.dart';
import '../../domain/entities/event_filter.dart';
import '../../domain/entities/event_page.dart';
import '../../domain/entities/event_summary.dart';
import '../models/event_mappers.dart';

class FirestoreEventCursor implements EventCursor {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  const FirestoreEventCursor(this.doc);
}

abstract interface class DiscoveryDataSource {
  Future<List<EventSummary>> featuredEvents();
  Future<List<EventSummary>> upcomingEvents();
  Future<List<EventCategory>> categories();
  Future<EventPage> events(
    EventFilter filter, {
    EventCursor? after,
    int pageSize = 20,
  });
  Future<EventDetail> eventDetail(String eventId);
}

@Singleton(as: DiscoveryDataSource)
class DiscoveryDataSourceImpl implements DiscoveryDataSource {
  final FirebaseFirestore _db;
  const DiscoveryDataSourceImpl(this._db);

  @override
  Future<List<EventSummary>> featuredEvents() => _run(() async {
    final snap = await _db
        .collection('events')
        .where('status', isEqualTo: 'published')
        .orderBy('ticketsSold', descending: true)
        .limit(10)
        .get();
    return [for (final d in snap.docs) mapEventSummary(d.id, d.data())];
  });

  @override
  Future<List<EventSummary>> upcomingEvents() => _run(() async {
    final snap = await _db
        .collection('events')
        .where('status', isEqualTo: 'published')
        .where('startAt', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('startAt')
        .limit(10)
        .get();
    return [for (final d in snap.docs) mapEventSummary(d.id, d.data())];
  });

  @override
  Future<List<EventCategory>> categories() => _run(() async {
    final snap = await _db
        .collection('categories')
        .where('status', isEqualTo: 'approved')
        .get();
    final list = [for (final d in snap.docs) mapCategory(d.id, d.data())];
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  });

  @override
  Future<EventPage> events(
    EventFilter filter, {
    EventCursor? after,
    int pageSize = 20,
  }) => _run(() async {
    var query = _buildQuery(filter);
    if (after is FirestoreEventCursor) {
      query = query.startAfterDocument(after.doc);
    }
    final snap = await query.limit(pageSize).get();
    return EventPage(
      events: [for (final d in snap.docs) mapEventSummary(d.id, d.data())],
      next: snap.docs.length < pageSize
          ? null
          : FirestoreEventCursor(snap.docs.last),
    );
  });

  @override
  Future<EventDetail> eventDetail(String eventId) => _run(() async {
    final eventRef = _db.collection('events').doc(eventId);
    final eventFut = eventRef.get();
    final contentFut = eventRef.collection('content').doc('main').get();
    final ttFut = eventRef.collection('ticketTypes').orderBy('sortOrder').get();
    final eventSnap = await eventFut;
    final contentSnap = await contentFut;
    final ttSnap = await ttFut;

    final data = eventSnap.data();
    if (data == null) {
      throw const BusinessException(
        'Sự kiện không tồn tại hoặc đã bị gỡ.',
        code: 'event_not_found',
      );
    }
    return mapEventDetail(
      id: eventSnap.id,
      event: data,
      content: contentSnap.data(),
      ticketTypes: [
        for (final d in ttSnap.docs) mapTicketTypeInfo(d.id, d.data()),
      ],
    );
  });

  Query<Map<String, dynamic>> _buildQuery(EventFilter f) {
    var q = _db.collection('events').where('status', isEqualTo: 'published');
    if (f.searchQuery.isNotEmpty) {
      q = q.where('titleSearch', arrayContains: searchPrefix(f.searchQuery));
    } else {
      if (f.categoryId != null) {
        q = q.where('categoryIds', arrayContains: f.categoryId);
      }
      if (f.provinceCode != null) {
        q = q.where('venue.provinceCode', isEqualTo: f.provinceCode);
      }
    }
    final range = _timeRange(f.timeRange);
    if (range != null) {
      q = q
          .where('startAt', isGreaterThanOrEqualTo: range.$1)
          .where('startAt', isLessThan: range.$2);
    }
    return q.orderBy('startAt');
  }

  (Timestamp, Timestamp)? _timeRange(EventTimeRange r) {
    if (r == EventTimeRange.all) return null;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    late final DateTime from;
    late final DateTime to;
    switch (r) {
      case EventTimeRange.today:
        from = today;
        to = today.add(const Duration(days: 1));
        break;
      case EventTimeRange.thisWeek:
        from = today.subtract(Duration(days: today.weekday - 1));
        to = from.add(const Duration(days: 7));
        break;
      case EventTimeRange.thisMonth:
        from = DateTime(today.year, today.month, 1);
        to = DateTime(today.year, today.month + 1, 1);
        break;
      case EventTimeRange.all:
        return null;
    }
    return (Timestamp.fromDate(from), Timestamp.fromDate(to));
  }

  Future<T> _run<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on FirebaseException catch (e) {
      throw mapFirestoreException(e);
    }
  }
}
