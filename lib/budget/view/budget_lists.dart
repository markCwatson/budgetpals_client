import 'package:budgetpals_client/add_expense/view/add_expense_page.dart';
import 'package:budgetpals_client/add_income/view/add_income_page.dart';
import 'package:budgetpals_client/auth/bloc/auth_bloc.dart';
import 'package:budgetpals_client/budget/bloc/budgets_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<String> titles = <String>[
  'Budget',
  'Expenses',
  'Income',
];

Map<String, BudgetsEvent> getEvents = <String, BudgetsEvent>{
  titles[0]: const GetBudgetEvent(),
  titles[1]: const GetExpensesEvent(),
  titles[2]: const GetIncomesEvent(),
};

Map<String, BudgetsEvent> addEvents = <String, BudgetsEvent>{
  titles[1]: const AddExpenseRequestEvent(),
  titles[2]: const AddIncomeRequestEvent(),
};

class BudgetsList extends StatefulWidget {
  const BudgetsList({
    super.key,
  });

  @override
  State<BudgetsList> createState() => _BudgetsListState();
}

class _BudgetsListState extends State<BudgetsList>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String _token = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 1, // default to expenses tab
    );
    _tabController!.addListener(_handleTabSelection);

    // Do initial load of expenses
    _setToken();
    context.read<BudgetsBloc>().add(const GetExpensesEvent());
  }

  void _handleTabSelection() {
    // dispatch the event based on the selected tab index
    if (_tabController!.indexIsChanging) {
      if (_tabController!.index >= titles.length) return;

      // post event to bloc
      _setToken();
      context
          .read<BudgetsBloc>()
          .add(getEvents[titles[_tabController!.index]]!);
    }
  }

  void _setToken() {
    // \todo: find a different way to manage this access token
    _token = context.read<AuthBloc>().state.token;
    context.read<BudgetsBloc>().add(SetTokenEvent(token: _token));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetsBloc, BudgetsState>(
      listener: (context, state) {
        if (state is BudgetGoToAddExpense) {
          Navigator.of(context).push(AddExpensePage.route()).then((value) {
            // Refresh the data when return to the Expenses page
            // \todo: use caching or something to avoid api call
            _setToken();
            context.read<BudgetsBloc>().add(const GetExpensesEvent());
          });
        }

        if (state is BudgetGoToAddIncome) {
          Navigator.of(context).push(AddIncomePage.route()).then((value) {
            // Refresh the data when return to the Incomes page
            // \todo: use caching or something to avoid api call
            _setToken();
            context.read<BudgetsBloc>().add(const GetIncomesEvent());
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('budgetpals'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout_sharp),
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                icon: const Icon(Icons.auto_graph_sharp),
                text: titles[0],
              ),
              Tab(
                icon: const Icon(Icons.shopping_cart_sharp),
                text: titles[1],
              ),
              Tab(
                icon: const Icon(Icons.monetization_on),
                text: titles[2],
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            BlocBuilder<BudgetsBloc, BudgetsState>(
              builder: (context, state) {
                return const LoadingIndicator();
              },
            ),
            BlocBuilder<BudgetsBloc, BudgetsState>(
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
            BlocBuilder<BudgetsBloc, BudgetsState>(
              builder: (context, state) {
                if (state.incomes.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.incomes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final income = state.incomes[index];
                      return IncomeCard(
                        id: income?.id ?? '',
                        amount: income?.amount ?? 0,
                        date: income?.date ?? '',
                        category: income?.category ?? '',
                        frequency: income?.frequency ?? '',
                        isEnding: income?.isEnding ?? false,
                        endDate: income?.endDate ?? '',
                        isFixed: income?.isFixed ?? false,
                      );
                    },
                  );
                }
                return const LoadingIndicator();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_tabController!.index == 0) return;
            context.read<BudgetsBloc>().add(
                  addEvents[titles[_tabController!.index]]!,
                );
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
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
              Text(
                'Category: $category',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Amount: \$${amount.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Date: ${date.replaceAll(RegExp('T.*'), '')}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Frequency: $frequency',
                style: const TextStyle(fontSize: 16),
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
        ),
      ),
    );
  }
}

class IncomeCard extends StatelessWidget {
  const IncomeCard({
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
      key: Key('dissmissibleIncomeCard-$id'),
      onDismissed: (direction) {
        context.read<BudgetsBloc>().add(
              DeleteIncomeRequestEvent(
                token: context.read<AuthBloc>().state.token,
                id: id,
              ),
            );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted $category Income'),
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
              Text(
                'Category: $category',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Amount: \$${amount.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Date: ${date.replaceAll(RegExp('T.*'), '')}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Frequency: $frequency',
                style: const TextStyle(fontSize: 16),
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
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
