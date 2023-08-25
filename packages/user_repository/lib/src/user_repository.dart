import 'dart:async';

import 'package:api/api.dart';
import 'package:user_repository/src/models/models.dart';

class UserRepository {
  UserRepository({required this.dataProvider});

  final UserDataProvider dataProvider;
  User? _user;

  Future<User?> getUser() async {
    if (_user != null) return _user;

    try {
      final data = await dataProvider.getUser();
      return _user = User(data['_id'] as String);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
