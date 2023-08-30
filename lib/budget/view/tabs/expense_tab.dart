import 'package:budgetpals_client/add_expense/view/add_expense_modal.dart';
import 'package:budgetpals_client/auth/bloc/auth_bloc.dart';
import 'package:budgetpals_client/budget/bloc/budgets_bloc.dart';
import 'package:budgetpals_client/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseTab extends StatelessWidget {
  const ExpenseTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BudgetsBloc, BudgetsState>(
        builder: (context, state) {
          if (state.expenses.isNotEmpty) {
            return ListView.builder(
              itemCount: state.expenses.length,
              itemBuilder: (BuildContext context, int index) {
                final expense = state.expenses[index];
                return ExpenseCard(
                  id: expense?.id ?? '',
                  amount: expense?.amount ?? 0,
                  date: expense?.date ?? '',
                  category: expense?.category ?? '',
                  frequency: expense?.frequency ?? '',
                  isEnding: expense?.isEnding ?? false,
                  endDate: expense?.endDate ?? '',
                  isFixed: expense?.isFixed ?? false,
                );
              },
            );
          }
          return const LoadingIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (ctx) => AddExpenseModal(),
          ).then(
            (value) {
              // Refresh the data when return to the Expenses page
              // \todo: use caching or something to avoid api call
              final token = context.read<AuthBloc>().state.token;
              context.read<BudgetsBloc>().add(SetTokenEvent(token: token));
              context.read<BudgetsBloc>().add(const GetExpensesEvent());
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    required this.id,
    required this.amount,
    required this.date,
    required this.category,
    required this.frequency,
    required this.isEnding,
    required this.endDate,
    required this.isFixed,
    super.key,
  });

  final String id;
  final double amount;
  final String date;
  final String category;
  final String frequency;
  final bool isEnding;
  final String endDate;
  final bool isFixed;

  @override
  Widget build(BuildContext context) {
    // \todo: consider different way to render if frequency is Once, etc.
    return Dismissible(
      key: Key('dissmissibleExpenseCard-$id'),
      onDismissed: (direction) {
        context.read<BudgetsBloc>().add(
              DeleteExpenseRequestEvent(
                token: context.read<AuthBloc>().state.token,
                id: id,
              ),
            );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted $category Expense'),
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isEnding) const SizedBox(height: 8),
                      if (isEnding)
                        Text(
                          'End Date: ${endDate.replaceAll(RegExp('T.*'), '')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      if (frequency != 'Once') const SizedBox(height: 8),
                      if (frequency != 'Once')
                        Text(
                          'Fixed amount: ${isFixed ? 'Yes' : 'No'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            date.replaceAll(RegExp('T.*'), ''),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.date_range_sharp,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Frequency: $frequency',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
