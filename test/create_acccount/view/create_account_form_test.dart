// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:budgetpals_client/screens/create_account/bloc/create_account_bloc.dart';
import 'package:budgetpals_client/screens/create_account/view/create_account_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
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

    testWidgets(
        'posts CreateAccountFirstNameChanged event when firstName is updated',
        (tester) async {
      const firstName = 'firstName';
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
        find.byKey(const Key('createAccountForm_firstNameInput_textField')),
        firstName,
      );
      verify(
        () => createAccountBloc.add(
          const CreateAccountFirstNameChanged(firstName),
        ),
      ).called(1);
    });

    testWidgets(
        'posts CreateAccountLastNameChanged event when lastName is updated',
        (tester) async {
      const lastName = 'lastName';
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
        find.byKey(const Key('createAccountForm_lastNameInput_textField')),
        lastName,
      );
      verify(
        () => createAccountBloc.add(
          const CreateAccountLastNameChanged(lastName),
        ),
      ).called(1);
    });

    testWidgets(
        'posts CreateAccountPasswordChanged event when password is updated',
        (tester) async {
      const password = 'password';
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
        find.byKey(const Key('createAccountForm_passwordInput_textField')),
        password,
      );
      verify(
        () => createAccountBloc.add(
          const CreateAccountPasswordChanged(password),
        ),
      ).called(1);
    });

    testWidgets(
        'loading indicator is shown when status is submission in progress',
        (tester) async {
      when(() => createAccountBloc.state).thenReturn(
        const CreateAccountState(status: FormzSubmissionStatus.inProgress),
      );
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
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('posts CreateAccountSubmitted event when continue is tapped',
        (tester) async {
      when(() => createAccountBloc.state)
          .thenReturn(const CreateAccountState(isValid: true));
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
      await tester.tap(find.byType(ElevatedButton));
      verify(
        () => createAccountBloc.add(const CreateAccountSubmitted()),
      ).called(1);
    });

    testWidgets('shows SnackBar when status is submission failure',
        (tester) async {
      whenListen(
        createAccountBloc,
        Stream.fromIterable([
          const CreateAccountState(status: FormzSubmissionStatus.inProgress),
          const CreateAccountState(status: FormzSubmissionStatus.failure),
        ]),
        initialState: const CreateAccountState(
          status: FormzSubmissionStatus.failure,
        ),
      );
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
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
