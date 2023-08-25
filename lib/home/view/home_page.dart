import 'package:budgetpals_client/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Builder(
              builder: (context) {
                final user = context.select(
                  (AuthBloc bloc) => bloc.state.user,
                );
                return Card(
                  margin: const EdgeInsets.all(24),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text('Email: ${user.email}'),
                    subtitle: Text('Name: ${user.firstName} ${user.lastName}'),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text('Logout'),
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            ),
          ],
        ),
      ),
    );
  }
}
