import 'package:budgetpals_client/add_expense/bloc/add_expense_bloc.dart';
import 'package:budgetpals_client/add_expense/view/add_expense_form.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class AddExpensePage extends StatelessWidget {
  const AddExpensePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AddExpensePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create an expense')),
      body: Padding(
        padding: EdgeInsets.zero,
        child: BlocProvider(
          create: (context) {
            return AddExpenseBloc(
              expensesRepository:
                  RepositoryProvider.of<ExpensesRepository>(context),
              userRepository: RepositoryProvider.of<UserRepository>(context),
            );
          },
          child: const AddExpenseForm(),
        ),
      ),
    );
  }
}
