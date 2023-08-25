import 'dart:async';

import 'package:api/api.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthRepository {
  AuthRepository({required this.dataProvider});

  final AuthDataProvider dataProvider;
  final _controller = StreamController<AuthStatus>();

  Stream<AuthStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    final data = await dataProvider.getToken(
      username: username,
      password: password,
    );

    // \todo: do a better check
    if (data['access_token'] != null) {
      _controller.add(AuthStatus.authenticated);
    } else {
      _controller.add(AuthStatus.unauthenticated);
    }
  }

  // \todo: implement logout
  void logOut() {
    _controller.add(AuthStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
