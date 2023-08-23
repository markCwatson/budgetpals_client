import 'package:flutter/material.dart';

import 'screens/auth.dart';

void main() => runApp(const BudgetpalsApp());

class BudgetpalsApp extends StatelessWidget {
  const BudgetpalsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'budgetpals',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
      ),
      home: const Scaffold(
        body: AuthScreen(),
      ),
    );
  }
}
