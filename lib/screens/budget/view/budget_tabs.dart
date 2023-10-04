import 'package:budgetpals_client/utilities/auth/bloc/auth_bloc.dart';
import 'package:budgetpals_client/screens/budget/bloc/budgets_bloc.dart';
import 'package:budgetpals_client/screens/budget/view/tabs/budget_tab.dart';
import 'package:budgetpals_client/screens/budget/view/tabs/expense_tab.dart';
import 'package:budgetpals_client/screens/budget/view/tabs/income_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<String> titles = <String>[
  'Budget',
  'Expenses',
  'Income',
];

class BudgetTabs extends StatefulWidget {
  const BudgetTabs({
    super.key,
  });

  @override
  State<BudgetTabs> createState() => _BudgetTabsState();
}

class _BudgetTabsState extends State<BudgetTabs>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabController!.addListener(_handleTabSelection);

    // Do initial load of budget info
    context.read<BudgetsBloc>().add(
          GetBudgetEvent(
            token: context.read<AuthBloc>().state.token,
          ),
        );
  }

  void _postEvent({
    required String token,
    required int index,
  }) {
    // Map <tab index, event>
    final events = <int, BudgetsEvent>{
      0: GetBudgetEvent(token: token),
      1: GetExpensesEvent(token: token),
      2: GetIncomesEvent(token: token),
    };

    context.read<BudgetsBloc>().add(
          events[_tabController!.index]!,
        );
  }

  void _handleTabSelection() {
    // dispatch the event based on the selected tab index
    if (_tabController!.indexIsChanging) {
      if (_tabController!.index >= titles.length) return;

      // post event to bloc
      _postEvent(
        token: context.read<AuthBloc>().state.token,
        index: _tabController!.index,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetsBloc, BudgetsState>(
      listener: (context, state) {},
      child: Scaffold(
        appBar: AppBar(
          title: const Text('budgetpals'),
          actions: <Widget>[
            const Icon(Icons.person),
            const SizedBox(width: 12),
            Text('Hi ${context.read<AuthBloc>().state.user.firstName}'),
            const SizedBox(width: 12),
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
          children: const <Widget>[
            BudgetTab(),
            ExpenseTab(),
            IncomeTab(),
          ],
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
