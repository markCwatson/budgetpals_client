part of 'create_account_bloc.dart';

final class CreateAccountState extends Equatable {
  const CreateAccountState({
    this.status = FormzSubmissionStatus.initial,
    this.username = const Username.pure(),
    this.firstName = const Name.pure(),
    this.lastName = const Name.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final Username username;
  final Name firstName;
  final Name lastName;
  final Password password;
  final bool isValid;

  CreateAccountState copyWith({
    FormzSubmissionStatus? status,
    Username? username,
    Name? firstName,
    Name? lastName,
    Password? password,
    bool? isValid,
  }) {
    return CreateAccountState(
      status: status ?? this.status,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [
        status,
        username,
        firstName,
        lastName,
        password,
      ];
}
