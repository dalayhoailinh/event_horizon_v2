import 'package:injectable/injectable.dart';

import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/event_category.dart';
import '../../domain/entities/event_detail.dart';
import '../../domain/entities/event_filter.dart';
import '../../domain/entities/event_page.dart';
import '../../domain/entities/event_summary.dart';
import '../../domain/repositories/discovery_repository.dart';
import '../datasources/discovery_datasource.dart';

@LazySingleton(as: DiscoveryRepository)
class DiscoveryRepositoryImpl implements DiscoveryRepository {
  final DiscoveryDataSource _ds;
  const DiscoveryRepositoryImpl(this._ds);

  @override
  Future<Result<List<EventSummary>>> featuredEvents() =>
      guard(_ds.featuredEvents);

  @override
  Future<Result<List<EventSummary>>> upcomingEvents() =>
      guard(_ds.upcomingEvents);

  @override
  Future<Result<List<EventCategory>>> categories() => guard(_ds.categories);

  @override
  Future<Result<EventPage>> events(
    EventFilter filter, {
    EventCursor? after,
    int pageSize = 20,
  }) => guard(() => _ds.events(filter, after: after, pageSize: pageSize));

  @override
  Future<Result<EventDetail>> eventDetail(String eventId) =>
      guard(() => _ds.eventDetail(eventId));
}
