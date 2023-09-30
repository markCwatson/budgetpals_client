import 'dart:async';

import 'package:budgetpals_client/data/providers/users/users_provider.dart';
import 'package:budgetpals_client/data/repositories/user/models/user.dart';

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

  Future<void> createAccount({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    await dataProvider.createAccount(
      email: email,
      firstName: firstName,
      lastName: lastName,
      password: password,
    );
  }
}
