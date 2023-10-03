import 'package:budgetpals_client/data/repositories/budgets/boxes/configuration_box.dart';
import 'package:budgetpals_client/data/repositories/budgets/models/budget.dart';
import 'package:budgetpals_client/data/repositories/expenses/boxes/expense_box.dart';
import 'package:budgetpals_client/data/repositories/incomes/boxes/income_box.dart';
import 'package:hive/hive.dart';

part 'budget_box.g.dart';

@HiveType(typeId: 20)
class BudgetBox extends HiveObject {
  @HiveField(0)
  late String userId;

  @HiveField(1)
  late ConfigurationBox configuration;

  @HiveField(2)
  late List<ExpenseBox> plannedExpenses;

  @HiveField(3)
  late List<IncomeBox> plannedIncomes;

  @HiveField(4)
  late List<ExpenseBox> unplannedExpenses;

  @HiveField(5)
  late List<IncomeBox> unplannedIncomes;

  Budget toBudget() {
    return Budget(
      userId,
      configuration.toConfiguration(),
      plannedExpenses.map((e) => e.toExpense()).toList(),
      plannedIncomes.map((e) => e.toIncome()).toList(),
      unplannedExpenses.map((e) => e.toExpense()).toList(),
      unplannedIncomes.map((e) => e.toIncome()).toList(),
    );
  }
}
