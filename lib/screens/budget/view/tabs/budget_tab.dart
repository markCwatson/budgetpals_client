import 'package:budgetpals_client/data/repositories/budgets/models/configuration.dart';
import 'package:budgetpals_client/data/repositories/common_models/expense.dart';
import 'package:budgetpals_client/data/repositories/common_models/generic.dart';
import 'package:budgetpals_client/data/repositories/common_models/income.dart';
import 'package:budgetpals_client/screens/add_expense/view/view.dart';
import 'package:budgetpals_client/screens/add_income/view/view.dart';
import 'package:budgetpals_client/screens/auth/auth.dart';
import 'package:budgetpals_client/screens/budget/bloc/budgets_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum BudgetTabType { expense, income }

class BudgetTab extends StatelessWidget {
  const BudgetTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<BudgetsBloc, BudgetsState>(
          builder: (context, state) {
            if (state.configuration != Configuration.empty) {
              return Column(
                children: [
                  Summary(
                    config: state.configuration,
                    endBalance: state.endAccountBalance,
                    startOfPeriod: state.currentPeriod.start,
                    endOfPeriod: state.currentPeriod.end,
                    totalPlannedExpenses: state.totalPlannedExpenses,
                    totalPlannedIncomes: state.totalPlannedIncomes,
                    totalUnplannedExpenses: state.totalUnplannedExpenses,
                    totalUnplannedIncomes: state.totalUnplannedIncomes,
                    adjustedEndAccountBalance: state.adjustedEndAccountBalance,
                  ),
                  BudgetedList<Expense>(
                    entries: state.plannedExpenses,
                    title: 'Planned Expenses in this Period',
                    type: BudgetTabType.expense,
                  ),
                  BudgetedList<Income>(
                    entries: state.plannedIncomes,
                    title: 'Planned Incomes in this Period',
                    type: BudgetTabType.income,
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class Summary extends StatefulWidget {
  const Summary({
    required this.config,
    required this.endBalance,
    required this.startOfPeriod,
    required this.endOfPeriod,
    required this.totalPlannedExpenses,
    required this.totalPlannedIncomes,
    required this.totalUnplannedExpenses,
    required this.totalUnplannedIncomes,
    required this.adjustedEndAccountBalance,
    super.key,
  });

  final Configuration config;
  final double endBalance;
  final DateTime? startOfPeriod;
  final DateTime? endOfPeriod;
  final double totalPlannedExpenses;
  final double totalPlannedIncomes;
  final double totalUnplannedExpenses;
  final double totalUnplannedIncomes;
  final double adjustedEndAccountBalance;

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Today's date: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateTime.now().toIso8601String().replaceAll(
                                RegExp('T.*'),
                                '',
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Current Account balance: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$ ${widget.config.runningBalance.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Start of this ${widget.config.period.toLowerCase()} period: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      widget.startOfPeriod!.toIso8601String().replaceAll(
                            RegExp('T.*'),
                            '',
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$ ${widget.config.startAccountBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Projection for end of period: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      widget.endOfPeriod!.toIso8601String().replaceAll(
                            RegExp('T.*'),
                            '',
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$ ${widget.endBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SummaryChart(
              totalPlannedExpenses: widget.totalPlannedExpenses,
              totalPlannedIncomes: widget.totalPlannedIncomes,
              endAccountBalance: widget.endBalance,
              totalUnplannedExpenses: widget.totalUnplannedExpenses,
              totalUnplannedIncomes: widget.totalUnplannedIncomes,
              adjustedEndAccountBalance: widget.adjustedEndAccountBalance,
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetedList<T extends FinanceEntry> extends StatefulWidget {
  const BudgetedList({
    required this.entries,
    required this.title,
    required this.type,
    super.key,
  });

  final List<T?> entries;
  final String title;
  final BudgetTabType type;

  @override
  State<BudgetedList<T>> createState() => _BudgetedListState<T>();
}

class _BudgetedListState<T extends FinanceEntry>
    extends State<BudgetedList<T>> {
  late List<T?> _entries;

  @override
  void initState() {
    super.initState();
    _entries = List.from(widget.entries);
  }

  double _computeTotal() {
    var total = 0.0;
    for (final entry in widget.entries) {
      total += entry!.amount;
    }
    return total;
  }

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
            Text(widget.title),
            const SizedBox(height: 16),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(),
                child: Column(
                  children: List.generate(
                    _entries.length,
                    (index) {
                      final entry = _entries[index]!;
                      return Dismissible(
                        key: Key('dissmissiblePlanned-${widget.type}-$index'),
                        onDismissed: (direction) {
                          setState(() {
                            _entries.removeAt(index);
                          });

                          if (widget.type == BudgetTabType.expense) {
                            context.read<BudgetsBloc>().add(
                                  DeletePlannedExpenseRequestEvent(
                                    token: context.read<AuthBloc>().state.token,
                                    id: entry.id,
                                  ),
                                );
                          } else {
                            context.read<BudgetsBloc>().add(
                                  DeletePlannedIncomeRequestEvent(
                                    token: context.read<AuthBloc>().state.token,
                                    id: entry.id,
                                  ),
                                );
                          }
                          final type = widget.type == BudgetTabType.expense
                              ? 'expense'
                              : 'income';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Deleted a planned $type'),
                            ),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.all(16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(entry.category),
                                  Text(
                                      entry.date.replaceAll(RegExp('T.*'), '')),
                                ],
                              ),
                              Text('\$ ${entry.amount.toStringAsFixed(2)}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.black38,
              thickness: 1,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$ ${_computeTotal().toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              key: Key('addEntry-${widget.type}-Button'),
              onPressed: widget.type == BudgetTabType.expense
                  ? () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (ctx) => AddExpenseModal(
                          title: 'Add a planned expense',
                          isPlanned: true,
                        ),
                      ).then(
                        (value) {
                          context.read<BudgetsBloc>().add(
                                const CacheResetEvent(),
                              );
                          // Refresh the data on return
                          context.read<BudgetsBloc>().add(
                                GetBudgetEvent(
                                  token: context.read<AuthBloc>().state.token,
                                ),
                              );
                        },
                      );
                    }
                  : () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (ctx) => AddIncomeModal(
                          title: 'Add a planned income',
                          isPlanned: true,
                        ),
                      ).then(
                        (value) {
                          context.read<BudgetsBloc>().add(
                                const CacheResetEvent(),
                              );
                          // Refresh the data on return
                          context.read<BudgetsBloc>().add(
                                GetBudgetEvent(
                                  token: context.read<AuthBloc>().state.token,
                                ),
                              );
                        },
                      );
                    },
              // \todo :add ability to edit
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

// \todo: move this to a separate file
class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}

class SummaryChart extends StatefulWidget {
  const SummaryChart({
    required this.totalPlannedExpenses,
    required this.totalPlannedIncomes,
    required this.endAccountBalance,
    required this.totalUnplannedExpenses,
    required this.totalUnplannedIncomes,
    required this.adjustedEndAccountBalance,
    super.key,
  });

  final double totalPlannedExpenses;
  final double totalPlannedIncomes;
  final double endAccountBalance;
  final double totalUnplannedExpenses;
  final double totalUnplannedIncomes;
  final double adjustedEndAccountBalance;

  @override
  State<SummaryChart> createState() => _SummaryChartState();
}

class _SummaryChartState extends State<SummaryChart> {
  late List<ChartData> plannedData;
  late List<ChartData> actualData;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    plannedData = [
      ChartData('Expenses', widget.totalPlannedExpenses),
      ChartData('Income', widget.totalPlannedIncomes),
      ChartData('Balance', widget.endAccountBalance),
    ];

    actualData = [
      ChartData('Expenses', widget.totalUnplannedExpenses),
      ChartData('Income', widget.totalUnplannedIncomes),
      ChartData('Balance', widget.adjustedEndAccountBalance),
    ];

    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: _tooltip,
          margin: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          backgroundColor: Colors.white,
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.bottom,
          ),
          series: <ChartSeries<ChartData, String>>[
            ColumnSeries<ChartData, String>(
              dataSource: plannedData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: 'Planned',
              color: const Color.fromRGBO(8, 142, 255, 1),
            ),
            ColumnSeries<ChartData, String>(
              opacity: 0.9,
              dataSource: actualData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: 'Actual',
            ),
          ],
        ),
      ),
    );
  }
}
