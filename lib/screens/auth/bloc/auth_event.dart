part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class _AuthStatusChanged extends AuthEvent {
  const _AuthStatusChanged(this.authToken);

  final AuthToken authToken;
}

final class AuthLogoutRequested extends AuthEvent {}
