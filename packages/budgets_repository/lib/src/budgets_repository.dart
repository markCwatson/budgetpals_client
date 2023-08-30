import 'dart:async';

import 'package:api/api.dart';
import 'package:budgets_repository/budgets_repository.dart';
import 'package:common_models/common_models.dart';

class BudgetsRepository {
  BudgetsRepository({required this.dataProvider});

  final BudgetsDataProvider dataProvider;

  Future<Budget?> getBudget(String token) async {
    try {
      final data = await dataProvider.getBudget(token);

      final expenses = (data['plannedExpenses'] as List).map((e) {
        e['endDate'] ??= '';
        return Expense.fromJson(e as Map<String, dynamic>);
      }).toList();

      final incomes = (data['plannedIncomes'] as List).map((e) {
        e['endDate'] ??= '';
        return Income.fromJson(e as Map<String, dynamic>);
      }).toList();

      return Budget(expenses, incomes);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
