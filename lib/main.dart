import 'package:budgetpals_client/app.dart';
import 'package:budgetpals_client/data/repositories/expenses/models/expense_box.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<ExpenseBox>(ExpenseBoxAdapter());
  await Hive.openBox<ExpenseBox>('expenses');
  runApp(const App());
}
