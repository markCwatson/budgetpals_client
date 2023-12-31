// ignore_for_file: prefer_const_constructors

import 'package:budgetpals_client/data/repositories/auth/auth_repository.dart';
import 'package:budgetpals_client/screens/login/view/login_form.dart';
import 'package:budgetpals_client/screens/login/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('LoginPage', () {
    late AuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
    });

    test('is routable', () {
      expect(LoginPage.route(), isA<MaterialPageRoute<void>>());
    });

    testWidgets('renders a LoginForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authRepository,
          child: MaterialApp(
            home: Scaffold(body: LoginPage()),
          ),
        ),
      );
      expect(find.byType(LoginForm), findsOneWidget);
    });
  });
}
