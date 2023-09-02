import 'package:budgetpals_client/add_expense/view/view.dart';
import 'package:budgetpals_client/add_income/view/view.dart';
import 'package:budgetpals_client/auth/auth.dart';
import 'package:budgetpals_client/budget/bloc/budgets_bloc.dart';
import 'package:budgetpals_client/utilities/utilities.dart';
import 'package:budgets_repository/budgets_repository.dart';
import 'package:common_models/common_models.dart';
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
        child: Column(
          children: [
            BlocBuilder<BudgetsBloc, BudgetsState>(
              builder: (context, state) {
                if (state.configuration != Configuration.empty) {
                  return Summary(
                    config: state.configuration,
                    endBalance: state.endAccountBalance,
                  );
                }
                return const Text('Error');
              },
            ),
            BlocBuilder<BudgetsBloc, BudgetsState>(
              builder: (context, state) {
                return BudgetedList<Expense>(
                  entries: state.plannedExpenses,
                  title: 'Planned Expenses in this Period',
                  type: BudgetTabType.expense,
                );
              },
            ),
            BlocBuilder<BudgetsBloc, BudgetsState>(
              builder: (context, state) {
                return BudgetedList<Income>(
                  entries: state.plannedIncomes,
                  title: 'Planned Incomes in this Period',
                  type: BudgetTabType.income,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Summary extends StatefulWidget {
  const Summary({
    required this.config,
    required this.endBalance,
    super.key,
  });

  final Configuration config;
  final double endBalance;

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  String _startOfPeriod = '';
  String _endOfPeriod = '';

  @override
  void initState() {
    super.initState();

    // Compute the start and end of the current period
    final createdAt = DateTime.parse(widget.config.startDate);
    final today = DateTime.now().toUtc();
    final currentPeriod = const PeriodCalculator().calculateCurrentPeriod(
      createdAt,
      widget.config.period,
      today,
    );

    _startOfPeriod =
        currentPeriod.start.toIso8601String().replaceAll(RegExp('T.*'), '');
    _endOfPeriod =
        currentPeriod.end.toIso8601String().replaceAll(RegExp('T.*'), '');
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
                ), // \todo: get data from bloc
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
                      _startOfPeriod,
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
                      _endOfPeriod,
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
            SummaryChart(),
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
                          // Refresh the data on return
                          // \todo: use caching or something to avoid api call
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
                          // Refresh the data on return
                          // \todo: use caching or something to avoid api call
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
  ChartData(this.x, this.y1, this.y2, this.y3);
  final String x;
  final double y1;
  final double y2;
  final double y3;
}

class SummaryChart extends StatelessWidget {
  SummaryChart({super.key});

  // \todo: get data from bloc
  // Expense, income, bank bal
  final List<ChartData> chartData = [
    ChartData('Jan', 3500, 3760, 500 + 3760 - 3500),
    ChartData('Feb', 2800, 2970, 760 + 2970 - 2800),
    ChartData('Mar', 3400, 3780, 900 + 3780 - 3400),
    ChartData('Apr', 3200, 3100, 1200 + 3100 - 3200),
    ChartData('May', 4000, 4575, 1100 + 4575 - 4000),
    ChartData('Jun', 3800, 4100, 1200 + 4100 - 3800),
    ChartData('Jul', 3800, 3900, 1400 + 4100 - 3800),
    ChartData('Aug', 3860, 4200, 1700 + 4100 - 3800),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(
            text: 'History',
            textStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          margin: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          backgroundColor: Colors.white,
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.bottom,
          ),
          series: <ChartSeries<ChartData, String>>[
            StepLineSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y1,
              name: 'Exp',
            ),
            StepLineSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y2,
              name: 'Inc',
            ),
            StepLineSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y3,
              color: Colors.green,
              name: 'Bal',
            ),
          ],
        ),
      ),
    );
  }
}
