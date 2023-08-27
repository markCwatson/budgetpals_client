import 'package:bloc/bloc.dart';
import 'package:budgetpals_client/create_account/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

part 'create_account_event.dart';
part 'create_account_state.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  CreateAccountBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const CreateAccountState()) {
    on<CreateAccountUsernameChanged>(_onUsernameChanged);
    on<CreateAccountFirstNameChanged>(_onFirsNameChanged);
    on<CreateAccountLastNameChanged>(_onLasNameChanged);
    on<CreateAccountPasswordChanged>(_onPasswordChanged);
    on<CreateAccountSubmitted>(_onCreateAccountSubmitted);
  }

  final UserRepository _userRepository;

  void _onUsernameChanged(
    CreateAccountUsernameChanged event,
    Emitter<CreateAccountState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([
          state.password,
          username,
          state.firstName,
          state.lastName,
        ]),
      ),
    );
  }

  void _onFirsNameChanged(
    CreateAccountFirstNameChanged event,
    Emitter<CreateAccountState> emit,
  ) {
    final firstName = Name.dirty(event.firstName);
    emit(
      state.copyWith(
        firstName: firstName,
        isValid: Formz.validate([
          state.password,
          state.username,
          firstName,
          state.lastName,
        ]),
      ),
    );
  }

  void _onLasNameChanged(
    CreateAccountLastNameChanged event,
    Emitter<CreateAccountState> emit,
  ) {
    final lastName = Name.dirty(event.lastName);
    emit(
      state.copyWith(
        lastName: lastName,
        isValid: Formz.validate([
          state.password,
          state.username,
          state.firstName,
          lastName,
        ]),
      ),
    );
  }

  void _onPasswordChanged(
    CreateAccountPasswordChanged event,
    Emitter<CreateAccountState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([
          password,
          state.username,
          state.firstName,
          state.lastName,
        ]),
      ),
    );
  }

  Future<void> _onCreateAccountSubmitted(
    CreateAccountSubmitted event,
    Emitter<CreateAccountState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _userRepository.createAccount(
          email: state.username.value,
          firstName: state.firstName.value,
          lastName: state.lastName.value,
          password: state.password.value,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
