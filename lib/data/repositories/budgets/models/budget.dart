import 'package:budgetpals_client/data/repositories/budgets/boxes/budget_box.dart';
import 'package:budgetpals_client/data/repositories/budgets/models/configuration.dart';
import 'package:budgetpals_client/data/repositories/common_models/expense.dart';
import 'package:budgetpals_client/data/repositories/common_models/income.dart';
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

  BudgetBox toBudgetBox() {
    final budgetBox = BudgetBox()
      ..userId = userId
      ..configuration = configuration.toConfigurationBox()
      ..plannedExpenses = plannedExpenses.map((e) => e.toExpenseBox()).toList()
      ..plannedIncomes = plannedIncomes.map((e) => e.toIncomeBox()).toList()
      ..unplannedExpenses =
          unplannedExpenses.map((e) => e.toExpenseBox()).toList()
      ..unplannedIncomes =
          unplannedIncomes.map((e) => e.toIncomeBox()).toList();
    return budgetBox;
  }
}
