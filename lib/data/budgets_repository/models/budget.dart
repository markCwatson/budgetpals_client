import 'package:budgetpals_client/data/common_models/expense.dart';
import 'package:budgetpals_client/data/common_models/income.dart';
import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  const Budget(
    this.userId,
    this.configuration,
    this.plannedExpenses,
    this.plannedIncomes,
    this.unplannedExpenses,
    this.unplannedIncomes,
  );

  final String userId;
  final Configuration configuration;
  final List<Expense> plannedExpenses;
  final List<Income> plannedIncomes;
  final List<Expense> unplannedExpenses;
  final List<Income> unplannedIncomes;

  @override
  List<Object> get props => [
        userId,
        configuration,
        plannedExpenses,
        plannedIncomes,
        unplannedExpenses,
        unplannedIncomes,
      ];

  static const empty = Budget(
    '',
    Configuration.empty,
    [],
    [],
    [],
    [],
  );
}

class Configuration {
  const Configuration(
    this.startDate,
    this.period,
    this.startAccountBalance,
    this.runningBalance,
  );

  Configuration.fromJson(Map<String, dynamic> json)
      : startDate = json['startDate'] as String,
        period = json['period'] as String,
        startAccountBalance = json['startAccountBalance'] as double,
        runningBalance = json['runningBalance'] as double;

  final String startDate;
  final String period;
  final double startAccountBalance;
  final double runningBalance;

  static const empty = Configuration('', '', 0, 0);
}
