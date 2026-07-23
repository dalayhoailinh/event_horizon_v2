import 'package:bloc_test/bloc_test.dart';
import 'package:event_horizon/core/result/result.dart';
import 'package:event_horizon/features/discovery/domain/entities/event_filter.dart';
import 'package:event_horizon/features/discovery/domain/entities/event_page.dart';
import 'package:event_horizon/features/discovery/domain/entities/event_summary.dart';
import 'package:event_horizon/features/discovery/domain/repositories/discovery_repository.dart';
import 'package:event_horizon/features/discovery/presentation/blocs/discovery_list/discovery_list_cubit.dart';
import 'package:event_horizon/features/discovery/presentation/blocs/discovery_list/discovery_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements DiscoveryRepository {}

class _FakeCursor extends Fake implements EventCursor {}

EventSummary e(String id) => EventSummary(
  id: id,
  title: id,
  coverImageUrl: '',
  startAt: DateTime(2026, 8, 1),
  venueName: '',
  provinceCode: 'SG',
  categoryNames: const [],
  minPrice: 0,
  maxPrice: 0,
  ticketsSold: 0,
  favoriteCount: 0,
  hasSeatMap: false,
);

void main() {
  late _MockRepo repo;
  final cursor = _FakeCursor();

  setUpAll(() {
    registerFallbackValue(const EventFilter());
    registerFallbackValue(_FakeCursor());
  });

  setUp(() {
    repo = _MockRepo();
    when(() => repo.categories()).thenAnswer((_) async => const Ok([]));
  });

  void stubPage(EventPage page) {
    when(
      () => repo.events(
        any(),
        after: any(named: 'after'),
        pageSize: any(named: 'pageSize'),
      ),
    ).thenAnswer((_) async => Ok(page));
  }

  blocTest<DiscoveryListCubit, DiscoveryListState>(
    'trang đầu: items + cursor (reset đầu tiên bị nuốt vì trùng initial)',
    build: () {
      stubPage(EventPage(events: [e('a'), e('b')], next: cursor));
      return DiscoveryListCubit(repo);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<DiscoveryListState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.events.length, 'events', 2)
          .having((s) => s.hasMore, 'hasMore', true),
    ],
  );

  blocTest<DiscoveryListCubit, DiscoveryListState>(
    'loadMore: append trang kế, hết cursor thì hasMore = false',
    build: () {
      stubPage(EventPage(events: [e('c'), e('d')], next: null));
      return DiscoveryListCubit(repo);
    },
    seed: () => DiscoveryListState(
      isLoading: false,
      events: [e('a'), e('b')],
      cursor: cursor,
    ),
    act: (cubit) => cubit.loadMore(),
    expect: () => [
      isA<DiscoveryListState>().having(
        (s) => s.isLoadingMore,
        'isLoadingMore',
        true,
      ),
      isA<DiscoveryListState>()
          .having((s) => s.events.length, 'events', 4)
          .having((s) => s.hasMore, 'hasMore', false),
    ],
  );

  blocTest<DiscoveryListCubit, DiscoveryListState>(
    'loadMore khi ĐÃ hết trang: không làm gì cả',
    build: () => DiscoveryListCubit(repo),
    seed: () =>
        DiscoveryListState(isLoading: false, events: [e('a')], cursor: null),
    act: (cubit) => cubit.loadMore(),
    expect: () => <DiscoveryListState>[],
    verify: (_) => verifyNever(
      () => repo.events(
        any(),
        after: any(named: 'after'),
        pageSize: any(named: 'pageSize'),
      ),
    ),
  );

  blocTest<DiscoveryListCubit, DiscoveryListState>(
    'search: reset list + XOÁ category/province đang chọn (ADR 2)',
    build: () {
      stubPage(EventPage(events: [e('x')], next: null));
      return DiscoveryListCubit(repo);
    },
    seed: () => DiscoveryListState(
      isLoading: false,
      events: [e('a')],
      filter: const EventFilter(categoryId: 'music', provinceCode: 'SG'),
    ),
    act: (cubit) => cubit.search('rock'),
    expect: () => [
      isA<DiscoveryListState>()
          .having((s) => s.isLoading, 'isLoading', true)
          .having((s) => s.events, 'events reset', isEmpty)
          .having((s) => s.filter.searchQuery, 'query', 'rock')
          .having((s) => s.filter.categoryId, 'category cleared', isNull)
          .having((s) => s.filter.provinceCode, 'province cleared', isNull),
      isA<DiscoveryListState>().having((s) => s.events.length, 'events', 1),
    ],
  );
}
