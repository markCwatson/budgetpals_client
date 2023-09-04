// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:budgetpals_client/create_account/create_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateAccountBloc
    extends MockBloc<CreateAccountEvent, CreateAccountState>
    implements CreateAccountBloc {}

void main() {
  group('CreateAccountForm', () {
    late CreateAccountBloc createAccountBloc;

    setUp(() {
      createAccountBloc = MockCreateAccountBloc();
    });

    testWidgets(
        'posts CreateAccountUsernameChanged event when username is updated',
        (tester) async {
      const username = 'email@email.com';
      when(() => createAccountBloc.state)
          .thenReturn(const CreateAccountState());
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: createAccountBloc,
              child: CreateAccountForm(),
            ),
          ),
        ),
      );
      await tester.enterText(
        find.byKey(const Key('createAccountForm_usernameInput_textField')),
        username,
      );
      verify(
        () => createAccountBloc.add(
          const CreateAccountUsernameChanged(username),
        ),
      ).called(1);
    });
  });
}
