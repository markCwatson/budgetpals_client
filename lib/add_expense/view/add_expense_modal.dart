import 'package:api/api.dart';
import 'package:budgetpals_client/add_expense/bloc/add_expense_bloc.dart';
import 'package:budgetpals_client/add_expense/view/add_expense_form.dart';
import 'package:budgetpals_client/auth/bloc/auth_bloc.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExpenseModal extends StatelessWidget {
  AddExpenseModal({super.key});

  static const url = String.fromEnvironment('API_URL');

  final ExpensesRepository _expensesRepository = ExpensesRepository(
    dataProvider: ExpensesDataProvider(baseUrl: url),
  );

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => AddExpenseModal());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 48, 8, 8),
      child: BlocProvider(
        create: (context) {
          final bloc = AddExpenseBloc(
            expensesRepository: _expensesRepository,
          )
            // Dispatch an events to fetching the categories/frequencies
            ..add(
              FetchCategoriesAndFrequenciesEvent(
                token: context.read<AuthBloc>().state.token,
              ),
            );
          return bloc;
        },
        child: const AddExpenseForm(),
      ),
    );
  }
}
