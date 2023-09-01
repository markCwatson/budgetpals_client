import 'package:budgetpals_client/auth/bloc/auth_bloc.dart';
import 'package:budgetpals_client/budget/bloc/budgets_bloc.dart';
import 'package:budgetpals_client/budget/view/tabs/tabs.dart';
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
    );
    _tabController!.addListener(_handleTabSelection);

    // Do initial load of expenses
    _setToken();
    context.read<BudgetsBloc>().add(const GetBudgetEvent());
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
