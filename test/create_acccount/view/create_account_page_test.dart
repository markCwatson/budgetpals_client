// ignore_for_file: prefer_const_constructors

import 'package:budgetpals_client/data/user_repository/user_repository.dart';
import 'package:budgetpals_client/screens/create_account/create_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('CreateAccountPage', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = MockUserRepository();
    });

    test('is routable', () {
      expect(CreateAccountPage.route(), isA<MaterialPageRoute<void>>());
    });

    testWidgets('renders a CreateAccountForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: userRepository,
          child: MaterialApp(
            home: Scaffold(body: CreateAccountPage()),
          ),
        ),
      );
      expect(find.byType(CreateAccountForm), findsOneWidget);
    });
  });
}
