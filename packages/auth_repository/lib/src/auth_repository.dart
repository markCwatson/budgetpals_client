import 'dart:async';

import 'package:api/api.dart';

class AuthToken {
  AuthToken({required this.token});
  final String token;
}

class AuthRepository {
  AuthRepository({required this.dataProvider});

  final AuthDataProvider dataProvider;
  final _controller = StreamController<AuthToken>();

  // expose Stream of AuthStatus updates to notify when user signs in/out
  Stream<AuthToken> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthToken(token: '');
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

    final authToken = AuthToken(token: data['access_token'] as String);
    _controller.add(authToken);
  }

  // \todo: implement logout
  void logOut() {
    _controller.add(AuthToken(token: ''));
  }

  void dispose() => _controller.close();
}
