import 'package:budgetpals_client/data/user_repository/user_repository.dart';
import 'package:budgetpals_client/screens/create_account/bloc/create_account_bloc.dart';
import 'package:budgetpals_client/screens/create_account/view/create_account_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const CreateAccountPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create an account')),
      body: Padding(
        padding: EdgeInsets.zero,
        child: BlocProvider(
          create: (context) {
            return CreateAccountBloc(
              userRepository: RepositoryProvider.of<UserRepository>(context),
            );
          },
          child: const CreateAccountForm(),
        ),
      ),
    );
  }
}
