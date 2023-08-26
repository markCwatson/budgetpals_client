import 'package:budgetpals_client/auth/bloc/auth_bloc.dart';
import 'package:budgetpals_client/budget/bloc/budgets_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<String> titles = <String>[
  'Budget',
  'Expenses',
  'Income',
];

Map<String, BudgetsEvent> events = <String, BudgetsEvent>{
  titles[0]: const GetBudgetEvent(),
  titles[1]: const GetExpensesEvent(),
  titles[2]: const GetIncomesEvent(),
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
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    // dispatch the event based on the selected tab index
    if (_tabController!.indexIsChanging) {
      if (_tabController!.index >= titles.length) return;

      // \todo: find a different way to manage this access token
      _token = context.read<AuthBloc>().state.token;
      context.read<BudgetsBloc>().add(SetTokenEvent(token: _token));

      // post event to bloc
      context.read<BudgetsBloc>().add(events[titles[_tabController!.index]]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetsBloc, BudgetsState>(
      listener: (context, state) {
        // print(state);
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
                        amount: expense?.amount ?? 0,
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
                return const LoadingIndicator();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your action here
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
    required this.amount,
    required this.category,
    required this.frequency,
    required this.isEnding,
    required this.endDate,
    required this.isFixed,
    super.key,
  });

  final int amount;
  final String category;
  final String frequency;
  final bool isEnding;
  final String endDate;
  final bool isFixed;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category: $category',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Amount: \$${amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Frequency: $frequency',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Is Ending: ${isEnding ? 'Yes' : 'No'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (isEnding)
              Text(
                'End Date: $endDate',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 8),
            Text(
              'Is Fixed: ${isFixed ? 'Yes' : 'No'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
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
