part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthRefreshRequested extends AuthEvent {
  const AuthRefreshRequested();
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
