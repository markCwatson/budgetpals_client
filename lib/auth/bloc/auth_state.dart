part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState._({
    this.token = '',
    this.user = User.empty,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(String token, User user)
      : this._(
          token: token,
          user: user,
        );

  const AuthState.unauthenticated()
      : this._(
          token: '',
          user: User.empty,
        );

  final String token;
  final User user;

  @override
  List<Object> get props => [token, user];
}
