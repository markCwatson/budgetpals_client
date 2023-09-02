import 'package:api/api.dart';
import 'package:budgetpals_client/add_budget/bloc/add_budget_bloc.dart';
import 'package:budgetpals_client/add_budget/view/configure_budget.dart';
import 'package:budgetpals_client/auth/auth.dart';
import 'package:budgets_repository/budgets_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The AddBudgetPage widget allows a user to configure their budget. It sets up
/// the BlocProvider for the AddBudgetBloc, which is responsible for managing
/// state for budget-related operations. The AddBudgetBloc manages the
/// configuration of the budget.
class AddBudgetPage extends StatelessWidget {
  AddBudgetPage({super.key});

  static const url = String.fromEnvironment('API_URL');

  final BudgetsRepository _budgetsRepository = BudgetsRepository(
    dataProvider: BudgetsDataProvider(baseUrl: url),
  );

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => AddBudgetPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = AddBudgetBloc(
          budgetsRepository: _budgetsRepository,
        )
          // Dispatch an event to fetch the periods if no budget exists for
          // this user
          ..add(
            EvaluateBudgetsEvent(
              token: context.read<AuthBloc>().state.token,
            ),
          );
        return bloc;
      },
      child: const ConfigureBudget(),
    );
  }
}
