import 'package:bloc_test/bloc_test.dart';
import 'package:event_horizon/core/result/failure.dart';
import 'package:event_horizon/core/result/result.dart';
import 'package:event_horizon/features/discovery/domain/entities/event_category.dart';
import 'package:event_horizon/features/discovery/domain/entities/event_summary.dart';
import 'package:event_horizon/features/discovery/domain/repositories/discovery_repository.dart';
import 'package:event_horizon/features/discovery/presentation/blocs/home/home_cubit.dart';
import 'package:event_horizon/features/discovery/presentation/blocs/home/home_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements DiscoveryRepository {}

void main() {
  late _MockRepo repo;

  final event = EventSummary(
    id: 'e1',
    title: 'A',
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
  const category = EventCategory(id: 'music', name: 'Âm nhạc');

  setUp(() {
    repo = _MockRepo();
    when(() => repo.featuredEvents()).thenAnswer((_) async => Ok([event]));
    when(() => repo.upcomingEvents()).thenAnswer((_) async => Ok([event]));
    when(() => repo.categories()).thenAnswer((_) async => const Ok([category]));
  });

  blocTest<HomeCubit, HomeState>(
    'load thành công: 3 section có dữ liệu trong 1 lần emit',
    build: () => HomeCubit(repo),
    act: (cubit) => cubit.load(),
    expect: () => [
      HomeState(
        isLoading: false,
        featured: [event],
        upcoming: [event],
        categories: [category],
      ),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'một nguồn lỗi -> failure, không hiển thị nửa vời',
    build: () {
      when(
        () => repo.upcomingEvents(),
      ).thenAnswer((_) async => const Err(NetworkFailure()));
      return HomeCubit(repo);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const HomeState(isLoading: false, failure: NetworkFailure()),
    ],
  );
}
