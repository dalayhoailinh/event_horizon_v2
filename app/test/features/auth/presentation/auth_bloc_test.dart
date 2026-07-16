import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:event_horizon/core/result/result.dart';
import 'package:event_horizon/features/auth/domain/entities/app_user.dart';
import 'package:event_horizon/features/auth/domain/repositories/auth_repository.dart';
import 'package:event_horizon/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:event_horizon/features/auth/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repo;
  late StreamController<AppUser?> authStream;

  const user = AppUser(
    id: 'u1',
    email: 'a@b.c',
    displayName: 'An',
    role: UserRole.user,
    emailVerified: true,
  );

  setUp(() {
    repo = _MockAuthRepository();
    authStream = StreamController<AppUser?>();
    when(() => repo.watchCurrentUser()).thenAnswer((_) => authStream.stream);
  });

  tearDown(() async {
    if (authStream.hasListener) {
      await authStream.close();
    }
  });

  blocTest<AuthBloc, AuthState>(
    'stream phát user -> authenticated; phát null -> unauthenticated',
    build: () => AuthBloc(repo),
    act: (bloc) async {
      bloc.add(const AuthStarted());
      authStream.add(user);
      await Future<void>.delayed(Duration.zero);
      authStream.add(null);
    },
    expect: () => [
      const AuthState.authenticated(user),
      const AuthState.unauthenticated(),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'logout gọi repository đúng 1 lần',
    build: () {
      when(() => repo.logout()).thenAnswer((_) async => const Ok(null));
      return AuthBloc(repo);
    },
    act: (bloc) => bloc.add(const AuthLogoutRequested()),
    verify: (_) => verify(() => repo.logout()).called(1),
  );
}
