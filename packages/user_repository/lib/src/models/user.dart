import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(this.id, this.firstName, this.lastName, this.email);

  final String id;
  final String firstName;
  final String lastName;
  final String email;

  @override
  List<Object> get props => [id, firstName, lastName, email];

  static const empty = User('', '', '', '');
}
