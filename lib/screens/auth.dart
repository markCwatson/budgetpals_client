import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _saveEmail(String email) {
    _enteredEmail = email;
    print(_enteredEmail);
  }

  void _savePassword(String password) {
    _enteredPassword = password;
    print(_enteredPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              margin: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EmailField(onSavedEmail: _saveEmail),
                      PasswordField(onSavedPassword: _savePassword),
                      Buttons(formKey: _formKey),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({super.key, required this.onSavedEmail});

  final Function(String) onSavedEmail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Enter Email',
        ),
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        validator: (value) {
          if (value == null || value.trim().isEmpty || !value.contains('@')) {
            return 'Please enter a valid email address.';
          }
          return null;
        },
        onSaved: (value) {
          onSavedEmail(value ?? '');
        },
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField({super.key, required this.onSavedPassword});

  final Function(String) onSavedPassword;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Enter Password',
        ),
        obscureText: true,
        validator: (value) {
          if (value == null || value.length < 6) {
            return 'Please enter a password with at least 6 characters.';
          }
          return null;
        },
        onSaved: (value) {
          onSavedPassword(value ?? '');
        },
      ),
    );
  }
}

class Buttons extends StatefulWidget {
  const Buttons({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  State<Buttons> createState() => _ButtonState();
}

class _ButtonState extends State<Buttons> {
  var _isLogin = false;

  void _onSubmit() {
    final isValid = widget.formKey.currentState!.validate();

    if (isValid) {
      widget.formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
            ),
            child: Text(_isLogin ? 'Log in' : 'Sign up'),
          ),
          const SizedBox(height: 8.0),
          TextButton(
            onPressed: () {
              setState(() {
                _isLogin = !_isLogin;
              });
            },
            child: Text(
                _isLogin ? 'Create an account' : 'I already have an account'),
          ),
        ],
      ),
    );
  }
}
