import 'package:api/api.dart';
import 'package:budgetpals_client/auth/auth.dart';
import 'package:budgetpals_client/budget/bloc/budgets_bloc.dart';
import 'package:budgetpals_client/budget/view/budget_tabs.dart';
import 'package:budgets_repository/budgets_repository.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incomes_repository/incomes_repository.dart';

/// The BudgetPage widget serves as the main container for displaying budget-
/// related information. It sets up the BlocProvider for the BudgetsBloc, which
/// is responsible for managing state for budget-related operations. BudgetPage
/// also initializes the DefaultTabController that helps to manage the tabs
/// within the budget section.
///
/// BlocProvider wraps BudgetTabs but is inside
/// DefaultTabController. In this setup, the BlocProvider would create
/// a new BudgetsBloc instance for every BudgetTabs but would not be
/// able to manage the state or behavior of the DefaultTabController
/// itself. This is likely ideal if BudgetsBloc is strictly needed for
/// the behavior in BudgetTabs.
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
        create: (context) {
          final bloc = BudgetsBloc(
            expensesRepository: _expensesRepository,
            incomesRepository: _incomesRepository,
            budgetsRepository: _budgetsRepository,
          )..add(
              GetBudgetEvent(
                token: context.read<AuthBloc>().state.token,
              ),
            );
          return bloc;
        },
        child: const BudgetTabs(),
      ),
    );
  }
}
