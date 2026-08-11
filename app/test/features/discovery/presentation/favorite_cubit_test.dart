import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:event_horizon/core/result/failure.dart';
import 'package:event_horizon/core/result/result.dart';
import 'package:event_horizon/features/discovery/domain/repositories/favorite_repository.dart';
import 'package:event_horizon/features/discovery/presentation/blocs/favorite/favorite_cubit.dart';
import 'package:event_horizon/features/discovery/presentation/blocs/favorite/favorite_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements FavoriteRepository {}

const _eventId = 'e1';

void main() {
  late _MockRepo repo;
  late StreamController<bool> stream;

  setUp(() {
    repo = _MockRepo();
    stream = StreamController<bool>();
    when(() => repo.watchIsFavorite(_eventId)).thenAnswer((_) => stream.stream);
  });

  tearDown(() => stream.close());

  blocTest<FavoriteCubit, FavoriteState>(
    'stream đẩy gì thì state theo đó',
    build: () => FavoriteCubit(repo),
    act: (cubit) async {
      cubit.start(_eventId);
      stream.add(true);
      await Future.delayed(Duration.zero);
      stream.add(false);
    },
    expect: () => const [
      FavoriteState(isFavorite: true),
      FavoriteState(isFavorite: false),
    ],
  );

  blocTest<FavoriteCubit, FavoriteState>(
    'toggle thành công: KHÔNG tự emit',
    build: () {
      when(
        () => repo.setFavorite(_eventId, value: true),
      ).thenAnswer((_) async => const Ok(null));
      return FavoriteCubit(repo);
    },
    act: (cubit) async {
      cubit.start(_eventId);
      await cubit.toggle();
    },
    expect: () => const <FavoriteState>[],
    verify: (_) => verify(() => repo.setFavorite(_eventId, value: true)),
  );

  blocTest<FavoriteCubit, FavoriteState>(
    'toggle lỗi: có message; messageShown() xoá đi để không hiện lại',
    build: () {
      when(() => repo.setFavorite(_eventId, value: true)).thenAnswer(
        (_) async => const Err(PermissionFailure('Bạn cần đăng nhập')),
      );
      return FavoriteCubit(repo);
    },
    act: (cubit) async {
      cubit.start(_eventId);
      await cubit.toggle();
      cubit.messageShown();
    },
    expect: () => const [
      FavoriteState(message: 'Bạn cần đăng nhập'),
      FavoriteState(),
    ],
  );
}
