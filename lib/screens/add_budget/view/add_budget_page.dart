import 'package:budgetpals_client/data/providers/budgets/budgets_provider.dart';
import 'package:budgetpals_client/data/repositories/budgets/budgets_repository.dart';
import 'package:budgetpals_client/screens/add_budget/bloc/add_budget_bloc.dart';
import 'package:budgetpals_client/screens/add_budget/view/configure_budget.dart';
import 'package:budgetpals_client/utilities/auth/bloc/auth_bloc.dart';
import 'package:budgetpals_client/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The AddBudgetPage widget allows a user to configure their budget. It sets up
/// the BlocProvider for the AddBudgetBloc, which is responsible for managing
/// state for budget-related operations. The AddBudgetBloc manages the
/// configuration of the budget.
class AddBudgetPage extends StatelessWidget {
  AddBudgetPage({super.key});

  static final url = Url.getUrl();

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
