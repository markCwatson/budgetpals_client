import 'package:bloc_test/bloc_test.dart';
import 'package:budgetpals_client/data/auth_repository/auth_repository.dart';
import 'package:budgetpals_client/screens/login/login.dart';
import 'package:budgetpals_client/screens/login/models/password.dart';
import 'package:budgetpals_client/screens/login/models/username.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  group('LoginBloc', () {
    test('initial state is LoginState', () {
      final loginBloc = LoginBloc(
        authRepository: authRepository,
      );
      expect(loginBloc.state, const LoginState());
    });

    group('LoginSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when login succeeds',
        setUp: () {
          when(
            () => authRepository.logIn(
              username: 'email@email.com',
              password: 'password',
            ),
          ).thenAnswer((_) => Future<String>.value('user'));
        },
        build: () => LoginBloc(
          authRepository: authRepository,
        ),
        act: (bloc) {
          bloc
            ..add(const LoginUsernameChanged('email@email.com'))
            ..add(const LoginPasswordChanged('password'))
            ..add(const LoginSubmitted());
        },
        expect: () => const <LoginState>[
          LoginState(username: Username.dirty('email@email.com')),
          LoginState(
            username: Username.dirty('email@email.com'),
            password: Password.dirty('password'),
            isValid: true,
          ),
          LoginState(
            username: Username.dirty('email@email.com'),
            password: Password.dirty('password'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          LoginState(
            username: Username.dirty('email@email.com'),
            password: Password.dirty('password'),
            isValid: true,
            status: FormzSubmissionStatus.success,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginInProgress, LoginFailure] when logIn fails',
        setUp: () {
          when(
            () => authRepository.logIn(
              username: 'email@email.com',
              password: 'password',
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginBloc(
          authRepository: authRepository,
        ),
        act: (bloc) {
          bloc
            ..add(const LoginUsernameChanged('email@email.com'))
            ..add(const LoginPasswordChanged('password'))
            ..add(const LoginSubmitted());
        },
        expect: () => const <LoginState>[
          LoginState(
            username: Username.dirty('email@email.com'),
          ),
          LoginState(
            username: Username.dirty('email@email.com'),
            password: Password.dirty('password'),
            isValid: true,
          ),
          LoginState(
            username: Username.dirty('email@email.com'),
            password: Password.dirty('password'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          LoginState(
            username: Username.dirty('email@email.com'),
            password: Password.dirty('password'),
            isValid: true,
            status: FormzSubmissionStatus.failure,
          ),
        ],
      );
    });

    group('LoginGoToCreateAccount', () {
      blocTest<LoginBloc, LoginState>(
        'emits [LoginGoToCreateAccount] '
        'user clicks create account button',
        setUp: () {},
        build: () => LoginBloc(
          authRepository: authRepository,
        ),
        act: (bloc) {
          bloc.add(const LoginGoToCreateAccount());
        },
        expect: () => const <LoginState>[
          LoginState(
            goToCreateAccount: true,
          ),
        ],
      );
    });
  });
}
