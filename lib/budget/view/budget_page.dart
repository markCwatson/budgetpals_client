import 'package:budgetpals_client/budget/bloc/budgets_bloc.dart';
import 'package:budgetpals_client/budget/view/budget_lists.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const BudgetPage());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: BlocProvider(
        create: (context) => BudgetsBloc(
          expensesRepository:
              RepositoryProvider.of<ExpensesRepository>(context),
        ),
        child: const BudgetsList(),
      ),
    );
  }
}
