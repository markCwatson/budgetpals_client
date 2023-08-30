import 'package:budgetpals_client/budget/bloc/budgets_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetTab extends StatelessWidget {
  const BudgetTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetsBloc, BudgetsState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              const Text('Budget Tab'),
              Text('Expenses: ${state.plannedExpenses.length}'),
              Text('Incomes: ${state.plannedIncomes.length}'),
            ],
          ),
        );
      },
    );
  }
}
