// ignore_for_file: prefer_const_constructors
import 'package:budgetpals_client/data/repositories/user/models/user.dart';
import 'package:budgetpals_client/utilities/auth/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

void main() {
  group('AuthState', () {
    group('AuthState.unknown', () {
      test('supports value comparisons', () {
        expect(
          AuthState.unknown(),
          AuthState.unknown(),
        );
      });
    });

    group('AuthState.authenticated', () {
      test('supports value comparisons', () {
        final user = MockUser();
        expect(
          AuthState.authenticated('token', user),
          AuthState.authenticated('token', user),
        );
      });
    });

    group('AuthState.unauthenticated', () {
      test('supports value comparisons', () {
        expect(
          AuthState.unauthenticated(),
          AuthState.unauthenticated(),
        );
      });
    });
  });
}
