import 'dart:async';

import 'package:api/api.dart';
import 'package:user_repository/src/models/models.dart';

class UserRepository {
  UserRepository({required this.dataProvider});

  final UserDataProvider dataProvider;
  User? _user;

  Future<User?> getUser(String token) async {
    if (_user != null) return _user;

    try {
      final data = await dataProvider.getUser(token);
      return _user = User(
        data['_id'] as String,
        data['firstName'] as String,
        data['lastName'] as String,
        data['email'] as String,
      );
    } catch (e) {
      return null;
    }
  }
}
