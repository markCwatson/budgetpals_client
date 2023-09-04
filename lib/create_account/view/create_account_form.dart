import 'package:budgetpals_client/create_account/bloc/create_account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class CreateAccountForm extends StatelessWidget {
  const CreateAccountForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateAccountBloc, CreateAccountState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Account Creation Failure')),
            );
        } else if (state.status.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Success! Account created!')),
            );
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });
        }
      },
      child: Scaffold(
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
                      _FirstNameInput(),
                      _LastNameInput(),
                      _PasswordInput(),
                      _SubmitButton(),
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
    return BlocBuilder<CreateAccountBloc, CreateAccountState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            key: const Key('createAccountForm_usernameInput_textField'),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            onChanged: (username) => context
                .read<CreateAccountBloc>()
                .add(CreateAccountUsernameChanged(username)),
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

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAccountBloc, CreateAccountState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            key: const Key('createAccountForm_firstNameInput_textField'),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            onChanged: (name) => context
                .read<CreateAccountBloc>()
                .add(CreateAccountFirstNameChanged(name)),
            decoration: InputDecoration(
              labelText: 'Enter first name',
              errorText:
                  state.username.displayError != null ? 'invalid name' : null,
            ),
          ),
        );
      },
    );
  }
}

class _LastNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAccountBloc, CreateAccountState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            key: const Key('createAccountForm_lastNameInput_textField'),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            onChanged: (name) => context
                .read<CreateAccountBloc>()
                .add(CreateAccountLastNameChanged(name)),
            decoration: InputDecoration(
              labelText: 'Enter last name',
              errorText:
                  state.username.displayError != null ? 'invalid name' : null,
            ),
          ),
        );
      },
    );
  }
}

// \todo: users should have to enter password twice to confirm
class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAccountBloc, CreateAccountState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            key: const Key('createAccountForm_passwordInput_textField'),
            onChanged: (password) => context
                .read<CreateAccountBloc>()
                .add(CreateAccountPasswordChanged(password)),
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

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAccountBloc, CreateAccountState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      key: const Key('accountCreateForm_continue_raisedButton'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: state.isValid
                          ? () {
                              context
                                  .read<CreateAccountBloc>()
                                  .add(const CreateAccountSubmitted());
                            }
                          : null,
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
