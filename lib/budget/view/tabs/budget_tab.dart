import 'package:budgetpals_client/budget/bloc/budgets_bloc.dart';
import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetTab extends StatelessWidget {
  const BudgetTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BlocBuilder<BudgetsBloc, BudgetsState>(
            builder: (context, state) {
              if (state.plannedExpenses.isNotEmpty) {
                return BudgetedList<Expense>(
                  entries: state.plannedExpenses,
                  title: 'Planned Expenses',
                );
              }
              return const Text('Get started');
            },
          ),
          BlocBuilder<BudgetsBloc, BudgetsState>(
            builder: (context, state) {
              if (state.plannedIncomes.isNotEmpty) {
                return BudgetedList<Income>(
                  entries: state.plannedIncomes,
                  title: 'Planned Incomes',
                );
              }
              return const Text('Get started');
            },
          ),
        ],
      ),
    );
  }
}

class BudgetedList<T extends FinanceEntry> extends StatelessWidget {
  const BudgetedList({
    required this.entries,
    required this.title,
    super.key,
  });

  final List<T?> entries;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            const SizedBox(height: 16),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(),
                child: Column(
                  children: List.generate(
                    entries.length,
                    (index) {
                      final entry = entries[index]!;
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Text(entry.category),
                            const Spacer(),
                            Text(entry.date.replaceAll(RegExp('T.*'), '')),
                            const Spacer(),
                            Text('\$ ${entry.amount.toStringAsFixed(2)}'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Icon(Icons.add_circle_outline_outlined),
          ],
        ),
      ),
    );
  }
}
