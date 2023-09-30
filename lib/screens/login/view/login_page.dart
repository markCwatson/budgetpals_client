import 'package:budgetpals_client/data/repositories/auth/auth_repository.dart';
import 'package:budgetpals_client/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: BlocProvider(
        create: (context) {
          return LoginBloc(
            authRepository: RepositoryProvider.of<AuthRepository>(context),
          );
        },
        child: const LoginForm(),
      ),
    );
  }
}
