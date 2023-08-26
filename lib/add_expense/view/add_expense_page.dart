import 'package:api/api.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:budgetpals_client/add_expense/bloc/add_expense_bloc.dart';
import 'package:budgetpals_client/add_expense/view/add_expense_form.dart';
import 'package:budgetpals_client/auth/bloc/auth_bloc.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class AddExpensePage extends StatelessWidget {
  AddExpensePage({super.key});

  static const url = String.fromEnvironment('API_URL');

  final ExpensesRepository _expensesRepository = ExpensesRepository(
    dataProvider: ExpensesDataProvider(baseUrl: url),
  );

  final UserRepository _usersRepository = UserRepository(
    dataProvider: UserDataProvider(baseUrl: url),
  );

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => AddExpensePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create an expense')),
      body: Padding(
        padding: EdgeInsets.zero,
        child: BlocProvider(
          create: (context) {
            final bloc = AddExpenseBloc(
              expensesRepository: _expensesRepository,
              userRepository: _usersRepository,
            )..add(
                // Dispatch an event to fetching the categories/frequencies
                FetchCategoriesEvent(
                  token: context.read<AuthBloc>().state.token,
                ),
              );
            return bloc;
          },
          child: const AddExpenseForm(),
        ),
      ),
    );
  }
}
