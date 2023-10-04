import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budgetpals_client/data/repositories/auth/auth_repository.dart';
import 'package:budgetpals_client/data/repositories/user/models/user.dart';
import 'package:budgetpals_client/data/repositories/user/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(const AuthState.unknown()) {
    // register event handlers
    on<_AuthStatusChanged>(_onAuthStatusChanged);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);

    // listen to (internal) auth status changes
    _authStatusSubscription = _authRepository.status.listen(
      (status) => add(_AuthStatusChanged(status)),
    );
  }

  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  late StreamSubscription<AuthToken> _authStatusSubscription;

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    return super.close();
  }

  // event handler for _AuthStatusChanged event
  Future<void> _onAuthStatusChanged(
    _AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) async {
    switch (event.authToken.token) {
      case '':
        return emit(const AuthState.unauthenticated());
      default:
        final user = await _tryGetUser(event.authToken.token);
        return emit(
          user != null
              ? AuthState.authenticated(event.authToken.token, user)
              : const AuthState.unauthenticated(),
        );
    }
  }

  // event handler for AuthLogoutRequested event
  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    _authRepository.logOut();
  }

  Future<User?> _tryGetUser(String token) async {
    try {
      final user = await _userRepository.getUser(token);
      return user;
    } catch (_) {
      return null;
    }
  }
}
