part of 'create_account_bloc.dart';

sealed class CreateAccountEvent extends Equatable {
  const CreateAccountEvent();

  @override
  List<Object> get props => [];
}

final class CreateAccountUsernameChanged extends CreateAccountEvent {
  const CreateAccountUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

final class CreateAccountFirstNameChanged extends CreateAccountEvent {
  const CreateAccountFirstNameChanged(this.firstName);

  final String firstName;

  @override
  List<Object> get props => [firstName];
}

final class CreateAccountLastNameChanged extends CreateAccountEvent {
  const CreateAccountLastNameChanged(this.lastName);

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

final class CreateAccountPasswordChanged extends CreateAccountEvent {
  const CreateAccountPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class CreateAccountSubmitted extends CreateAccountEvent {
  const CreateAccountSubmitted();
}
