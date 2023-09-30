import 'package:bloc/bloc.dart';
import 'package:budgetpals_client/data/auth_repository/auth_repository.dart';
import 'package:budgetpals_client/screens/login/models/password.dart';
import 'package:budgetpals_client/screens/login/models/username.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginGoToCreateAccount>(_onGoToCreateAccount);
    on<LoginResetGoToCreateAccount>(_onResetGoToCreateAccount);
  }

  final AuthRepository _authRepository;

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([state.password, username]),
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.username]),
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _authRepository.logIn(
          username: state.username.value,
          password: state.password.value,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }

  Future<void> _onGoToCreateAccount(
    LoginGoToCreateAccount event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(goToCreateAccount: true));
  }

  Future<void> _onResetGoToCreateAccount(
    LoginResetGoToCreateAccount event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(goToCreateAccount: false));
  }
}
