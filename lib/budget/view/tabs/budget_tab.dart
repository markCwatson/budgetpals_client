import 'package:budgetpals_client/add_income/models/date.dart';
import 'package:budgetpals_client/budget/bloc/budgets_bloc.dart';
import 'package:budgets_repository/budgets_repository.dart';
import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
      ),
    );
  }
}

class Summary extends StatelessWidget {
  const Summary({
    required this.config,
    required this.endBalance,
    super.key,
  });

  final Configuration config;
  final double endBalance;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text(
                      'Start',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateTime(2023, 8, 31)
                          .toIso8601String()
                          .replaceAll(RegExp('T.*'), ''),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$ ${config.startAccountBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'End',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateTime(2023, 9, 13)
                          .toIso8601String()
                          .replaceAll(RegExp('T.*'), ''),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      // \todo: calculate the follwoing dynamcially in bloc
                      '\$ ${endBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateTime(2023, 9, 5)
                          .toIso8601String()
                          .replaceAll(RegExp('T.*'), ''),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$ ${config.runningBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // \todo: calculate the follwoing dynamcially in bloc
            // const SizedBox(height: 16),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Column(
            //       children: [
            //         Text(
            //           'SOY',
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ), // start of year
            //         Text('\$ 269.43'),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         Text(
            //           'EOY',
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ), // end of year
            //         Text('\$ 9760.00'),
            //       ],
            //     ),
            //   ],
            // ),
            SummaryChart(),
          ],
        ),
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

  // ]todo: get data from bloc
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
            text: 'Monthly Summary',
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
