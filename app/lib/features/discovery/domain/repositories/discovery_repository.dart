import '../../../../core/result/result.dart';
import '../entities/event_category.dart';
import '../entities/event_detail.dart';
import '../entities/event_filter.dart';
import '../entities/event_page.dart';
import '../entities/event_summary.dart';

abstract interface class DiscoveryRepository {
  Future<Result<List<EventSummary>>> featuredEvents();
  Future<Result<List<EventSummary>>> upcomingEvents();
  Future<Result<List<EventCategory>>> categories();
  Future<Result<EventPage>> events(
    EventFilter filter, {
    EventCursor? after,
    int pageSize,
  });
  Future<Result<EventDetail>> eventDetail(String eventId);
}
