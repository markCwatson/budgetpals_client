import 'package:budgetpals_client/data/providers/expenses/expenses_provider.dart';
import 'package:budgetpals_client/data/repositories/expenses/expenses_repository.dart';
import 'package:budgetpals_client/screens/add_expense/bloc/add_expense_bloc.dart';
import 'package:budgetpals_client/screens/add_expense/view/add_expense_form.dart';
import 'package:budgetpals_client/utilities/auth/bloc/auth_bloc.dart';
import 'package:budgetpals_client/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExpenseModal extends StatelessWidget {
  AddExpenseModal({
    required this.title,
    required this.isPlanned,
    super.key,
  });

  final String title;
  final bool isPlanned;

  static final url = Url.getUrl();

  final ExpensesRepository _expensesRepository = ExpensesRepository(
    dataProvider: ExpensesDataProvider(baseUrl: url),
  );

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => AddExpenseModal(
        title: 'Add an expense',
        isPlanned: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 48, 8, 8),
        child: BlocProvider(
          create: (context) {
            final bloc = AddExpenseBloc(
              expensesRepository: _expensesRepository,
            )
              // Dispatch an event to fetch the categories/frequencies
              ..add(
                FetchCategoriesAndFrequenciesEvent(
                  token: context.read<AuthBloc>().state.token,
                ),
              );
            return bloc;
          },
          child: AddExpenseForm(
            title: title,
            isPlanned: isPlanned,
          ),
        ),
      ),
    );
  }
}
