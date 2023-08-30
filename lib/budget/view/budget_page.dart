import 'package:api/api.dart';
import 'package:budgetpals_client/budget/bloc/budgets_bloc.dart';
import 'package:budgetpals_client/budget/view/budget_lists.dart';
import 'package:budgets_repository/budgets_repository.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incomes_repository/incomes_repository.dart';

class BudgetPage extends StatelessWidget {
  BudgetPage({super.key});

  static const url = String.fromEnvironment('API_URL');

  final ExpensesRepository _expensesRepository = ExpensesRepository(
    dataProvider: ExpensesDataProvider(baseUrl: url),
  );

  final IncomesRepository _incomesRepository = IncomesRepository(
    dataProvider: IncomesDataProvider(baseUrl: url),
  );

  final BudgetsRepository _budgetsRepository = BudgetsRepository(
    dataProvider: BudgetsDataProvider(baseUrl: url),
  );

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => BudgetPage());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocProvider(
        create: (context) => BudgetsBloc(
          expensesRepository: _expensesRepository,
          incomesRepository: _incomesRepository,
          budgetsRepository: _budgetsRepository,
        ),
        child: const BudgetsList(),
      ),
    );
  }
}
