import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:budgetpals_client/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  const user = User('id', 'username', 'firstName', 'lastName');
  late AuthRepository authRepository;
  late UserRepository userRepository;

  setUp(() {
    authRepository = _MockAuthRepository();
    when(
      () => authRepository.status,
    ).thenAnswer((_) => const Stream.empty());
    userRepository = _MockUserRepository();
  });

  group('AuthBloc', () {
    test('initial state is AuthState.unknown', () {
      final authBloc = AuthBloc(
        authRepository: authRepository,
        userRepository: userRepository,
      );
      expect(authBloc.state, const AuthState.unknown());
      authBloc.close();
    });

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when status is unauthenticated',
      setUp: () {
        when(() => authRepository.status).thenAnswer(
          (_) => Stream.value(AuthToken(token: '')),
        );
      },
      build: () => AuthBloc(
        authRepository: authRepository,
        userRepository: userRepository,
      ),
      expect: () => const <AuthState>[
        AuthState.unauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [authenticated] when status is authenticated',
      setUp: () {
        when(() => authRepository.status).thenAnswer(
          (_) => Stream.value(AuthToken(token: 'token')),
        );
        when(() => userRepository.getUser('token'))
            .thenAnswer((_) async => user);
      },
      build: () => AuthBloc(
        authRepository: authRepository,
        userRepository: userRepository,
      ),
      expect: () => const <AuthState>[
        AuthState.authenticated('token', user),
      ],
    );
  });

  group('AuthStateChanged', () {
    blocTest<AuthBloc, AuthState>(
      'emits [authenticated] when status is authenticated',
      setUp: () {
        when(
          () => authRepository.status,
        ).thenAnswer((_) => Stream.value(AuthToken(token: 'token')));
        when(() => userRepository.getUser('token'))
            .thenAnswer((_) async => user);
      },
      build: () => AuthBloc(
        authRepository: authRepository,
        userRepository: userRepository,
      ),
      expect: () => const <AuthState>[
        AuthState.authenticated('token', user),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when status is unauthenticated',
      setUp: () {
        when(
          () => authRepository.status,
        ).thenAnswer((_) => Stream.value(AuthToken(token: 'token')));
      },
      build: () => AuthBloc(
        authRepository: authRepository,
        userRepository: userRepository,
      ),
      expect: () => const <AuthState>[
        AuthState.unauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when status is authenticated but getUser fails',
      setUp: () {
        when(
          () => authRepository.status,
        ).thenAnswer((_) => Stream.value(AuthToken(token: 'token')));
        when(() => userRepository.getUser('token'))
            .thenThrow(Exception('oops'));
      },
      build: () => AuthBloc(
        authRepository: authRepository,
        userRepository: userRepository,
      ),
      expect: () => const <AuthState>[
        AuthState.unauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when status is authenticated '
      'but getUser returns null',
      setUp: () {
        when(
          () => authRepository.status,
        ).thenAnswer((_) => Stream.value(AuthToken(token: 'token')));
        when(() => userRepository.getUser('token'))
            .thenAnswer((_) async => null);
      },
      build: () => AuthBloc(
        authRepository: authRepository,
        userRepository: userRepository,
      ),
      expect: () => const <AuthState>[
        AuthState.unauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unknown] when status is unknown',
      setUp: () {
        when(
          () => authRepository.status,
        ).thenAnswer((_) => Stream.value(AuthToken(token: '')));
      },
      build: () => AuthBloc(
        authRepository: authRepository,
        userRepository: userRepository,
      ),
      expect: () => const <AuthState>[
        AuthState.unknown(),
      ],
    );
  });

  group('AuthLogoutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'calls logOut on authRepository '
      'when AuthLogoutRequested is added',
      build: () => AuthBloc(
        authRepository: authRepository,
        userRepository: userRepository,
      ),
      act: (bloc) => bloc.add(AuthLogoutRequested()),
      verify: (_) {
        verify(() => authRepository.logOut()).called(1);
      },
    );
  });
}
