import 'package:budgetpals_client/app.dart';
import 'package:budgetpals_client/data/repositories/budgets/budgets_repository.dart';
import 'package:budgetpals_client/data/repositories/expenses/expenses_repository.dart';
import 'package:budgetpals_client/data/repositories/incomes/incomes_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await _initializeBoxes();
  runApp(const App());
}

Future<void> _initializeBoxes() async {
  try {
    await ExpensesRepository.initializeBoxes();
    await IncomesRepository.initializeBoxes();
    await BudgetsRepository.initializeBoxes();
  } catch (e) {
    print(e);
  }
}
