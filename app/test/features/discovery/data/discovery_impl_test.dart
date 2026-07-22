import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_horizon/core/result/failure.dart';
import 'package:event_horizon/core/result/result.dart';
import 'package:event_horizon/features/discovery/data/datasources/discovery_datasource.dart';
import 'package:event_horizon/features/discovery/data/repositories/discovery_repository_impl.dart';
import 'package:event_horizon/features/discovery/domain/entities/event_detail.dart';
import 'package:event_horizon/features/discovery/domain/entities/event_filter.dart';
import 'package:event_horizon/features/discovery/domain/entities/event_page.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore db;
  late DiscoveryRepositoryImpl repo;

  setUp(() {
    db = FakeFirebaseFirestore();
    repo = DiscoveryRepositoryImpl(DiscoveryDataSourceImpl(db));
  });

  Future<void> seedEvent(
    String id, {
    String status = 'published',
    int startInDays = 10,
    String title = 'Đêm nhạc',
  }) {
    final start = DateTime.now().add(Duration(days: startInDays));
    return db.doc('events/$id').set({
      'title': title,
      'titleSearch': ['d', 'de', 'dem', 'n', 'nh', 'nha', 'nhac'],
      'coverImageUrl': '',
      'startAt': Timestamp.fromDate(start),
      'endAt': Timestamp.fromDate(start.add(const Duration(hours: 3))),
      'venue': {
        'name': 'Nhà văn hoá',
        'address': '1 Đường A',
        'provinceCode': 'SG',
      },
      'categoryIds': ['music'],
      'categoryNames': ['Âm nhạc'],
      'organizerId': 'org1',
      'organizerName': 'Demo',
      'status': status,
      'minPrice': 200000,
      'maxPrice': 500000,
      'ticketsSold': 5,
      'favoriteCount': 0,
      'maxBookingsPerUser': 4,
      'hasSeatMap': false,
    });
  }

  test('events(): chỉ trả published, sort theo startAt tăng dần', () async {
    await seedEvent('a', startInDays: 20);
    await seedEvent('b', startInDays: 3);
    await seedEvent('c', status: 'draft');

    final result = await repo.events(const EventFilter());

    final page = (result as Ok<EventPage>).value;
    expect([for (final e in page.events) e.id], ['b', 'a']);
  });

  test('phân trang: cursor đi hết 3 doc với pageSize 2', () async {
    await seedEvent('a', startInDays: 1);
    await seedEvent('b', startInDays: 2);
    await seedEvent('c', startInDays: 3);

    final r1 = await repo.events(const EventFilter(), pageSize: 2);
    final page1 = (r1 as Ok<EventPage>).value;
    expect(page1.events.length, 2);
    expect(page1.next, isNotNull);

    final r2 = await repo.events(
      const EventFilter(),
      after: page1.next,
      pageSize: 2,
    );
    final page2 = (r2 as Ok<EventPage>).value;
    expect([for (final e in page2.events) e.id], ['c']);
    expect(page2.next, isNull);
  });

  test('search bỏ dấu: query "Đêm" khớp titleSearch "dem', () async {
    await seedEvent('a');

    final result = await repo.events(const EventFilter(searchQuery: 'Đêm'));

    expect((result as Ok<EventPage>).value.events.length, 1);
  });

  test('eventDetail ghép event + content + ticketTypes', () async {
    await seedEvent('a');
    await db.doc('events/a/content/main').set({
      'descriptionPlain': 'Mô tả sự kiện',
      'galleryUrls': ['url1', 'url2'],
    });
    await db.doc('events/a/ticketTypes/tt1').set({
      'name': 'Vé thường',
      'description': 'Vé thường',
      'price': 200000,
      'quantity': 100,
      'sold': 5,
      'sortOrder': 0,
      'isActive': true,
    });

    final result = await repo.eventDetail('a');
    final detail = (result as Ok<EventDetail>).value;

    expect(detail.summary.title, 'Đêm nhạc');
    expect(detail.descriptionPlain, 'Mô tả sự kiện');
    expect(detail.ticketTypes.single.remaining, 95);
  });

  test('eventDetail: id không tồn tại -> Err(BusinessFailure)', () async {
    final result = await repo.eventDetail('not-exist');
    expect(result, isA<Err<EventDetail>>());
    final failure = (result as Err<EventDetail>).failure;
    expect(failure, isA<BusinessFailure>());
    expect((failure as BusinessFailure).code, 'event_not_found');
  });
}
