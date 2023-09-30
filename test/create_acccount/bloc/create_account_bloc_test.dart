import 'package:bloc_test/bloc_test.dart';
import 'package:budgetpals_client/data/user_repository/user_repository.dart';
import 'package:budgetpals_client/screens/create_account/create_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late UserRepository userRepository;

  setUp(() {
    userRepository = MockUserRepository();
  });

  group('CreateAccountBloc', () {
    test('initial state is CreateAccountState', () {
      final createAccountBloc = CreateAccountBloc(
        userRepository: userRepository,
      );
      expect(createAccountBloc.state, const CreateAccountState());
    });

    group('CreateAccountSubmitted', () {
      blocTest<CreateAccountBloc, CreateAccountState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when create account succeeds',
        setUp: () {
          when(
            () => userRepository.createAccount(
              email: 'email@email.com',
              password: 'password',
              firstName: 'firstName',
              lastName: 'lastName',
            ),
          ).thenAnswer((_) => Future<void>.value());
        },
        build: () => CreateAccountBloc(
          userRepository: userRepository,
        ),
        act: (bloc) {
          bloc
            ..add(const CreateAccountUsernameChanged('email@email.com'))
            ..add(const CreateAccountFirstNameChanged('firstName'))
            ..add(const CreateAccountLastNameChanged('lastName'))
            ..add(const CreateAccountPasswordChanged('password'))
            ..add(const CreateAccountSubmitted());
        },
        expect: () => const <CreateAccountState>[
          CreateAccountState(username: Username.dirty('email@email.com')),
          CreateAccountState(
            username: Username.dirty('email@email.com'),
            firstName: Name.dirty('firstName'),
          ),
          CreateAccountState(
            username: Username.dirty('email@email.com'),
            firstName: Name.dirty('firstName'),
            lastName: Name.dirty('lastName'),
          ),
          CreateAccountState(
            username: Username.dirty('email@email.com'),
            password: Password.dirty('password'),
            firstName: Name.dirty('firstName'),
            lastName: Name.dirty('lastName'),
            isValid: true,
          ),
          CreateAccountState(
            username: Username.dirty('email@email.com'),
            password: Password.dirty('password'),
            firstName: Name.dirty('firstName'),
            lastName: Name.dirty('lastName'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          CreateAccountState(
            username: Username.dirty('email@email.com'),
            password: Password.dirty('password'),
            firstName: Name.dirty('firstName'),
            lastName: Name.dirty('lastName'),
            isValid: true,
            status: FormzSubmissionStatus.success,
          ),
        ],
      );

      blocTest<CreateAccountBloc, CreateAccountState>(
        'emits [submissionInProgress, failure] '
        'when create account fails',
        setUp: () {
          when(
            () => userRepository.createAccount(
              email: 'email@email.com',
              password: 'password',
              firstName: 'firstName',
              lastName: 'lastName',
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => CreateAccountBloc(
          userRepository: userRepository,
        ),
        act: (bloc) {
          bloc
            ..add(const CreateAccountUsernameChanged('email@email.com'))
            ..add(const CreateAccountFirstNameChanged('firstName'))
            ..add(const CreateAccountLastNameChanged('lastName'))
            ..add(const CreateAccountPasswordChanged('password'))
            ..add(const CreateAccountSubmitted());
        },
        expect: () => const <CreateAccountState>[
          CreateAccountState(username: Username.dirty('email@email.com')),
          CreateAccountState(
            username: Username.dirty('email@email.com'),
            firstName: Name.dirty('firstName'),
          ),
          CreateAccountState(
            username: Username.dirty('email@email.com'),
            firstName: Name.dirty('firstName'),
            lastName: Name.dirty('lastName'),
          ),
          CreateAccountState(
            username: Username.dirty('email@email.com'),
            password: Password.dirty('password'),
            firstName: Name.dirty('firstName'),
            lastName: Name.dirty('lastName'),
            isValid: true,
          ),
          CreateAccountState(
            username: Username.dirty('email@email.com'),
            password: Password.dirty('password'),
            firstName: Name.dirty('firstName'),
            lastName: Name.dirty('lastName'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          CreateAccountState(
            username: Username.dirty('email@email.com'),
            password: Password.dirty('password'),
            firstName: Name.dirty('firstName'),
            lastName: Name.dirty('lastName'),
            isValid: true,
            status: FormzSubmissionStatus.failure,
          ),
        ],
      );
    });
  });
}
