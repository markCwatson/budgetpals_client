import 'package:budgetpals_client/create_account/view/create_account_page.dart';
import 'package:budgetpals_client/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.goToCreateAccount) {
          Navigator.of(context).push(CreateAccountPage.route());
        }

        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Auth Failure')),
            );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                margin: const EdgeInsets.all(32),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _UsernameInput(),
                      _PasswordInput(),
                      _LoginButton(),
                      _CreateAccountButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            key: const Key('loginForm_usernameInput_textField'),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            onChanged: (username) =>
                context.read<LoginBloc>().add(LoginUsernameChanged(username)),
            decoration: InputDecoration(
              labelText: 'Enter email',
              errorText: state.username.displayError != null
                  ? 'invalid username'
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<LoginBloc>().add(LoginPasswordChanged(password)),
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Enter password',
              errorText: state.password.displayError != null
                  ? 'invalid password'
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: state.isValid
                      ? () {
                          context.read<LoginBloc>().add(const LoginSubmitted());
                        }
                      : null,
                  child: const Text('Login'),
                ),
              );
      },
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.goToCreateAccount) {
          context.read<LoginBloc>().add(const LoginResetGoToCreateAccount());
        }
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextButton(
                  key:
                      const Key('loginCreateAccountForm_continue_raisedButton'),
                  onPressed: () => context
                      .read<LoginBloc>()
                      .add(const LoginGoToCreateAccount()),
                  child: const Text('Create an account'),
                ),
              );
      },
    );
  }
}
