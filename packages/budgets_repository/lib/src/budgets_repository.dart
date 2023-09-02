import 'dart:async';
import 'dart:convert';

import 'package:api/api.dart';
import 'package:budgets_repository/budgets_repository.dart';
import 'package:common_models/common_models.dart';

class BudgetsRepository {
  BudgetsRepository({required this.dataProvider});

  final BudgetsDataProvider dataProvider;

  Future<Budget?> getBudget(String token) async {
    try {
      final data = await dataProvider.getBudget(token);

      final userId = data['userId'] as String;

      final configuration = Configuration.fromJson(
        data['configuration'] as Map<String, dynamic>,
      );

      final unplannedExpenses = (data['unplannedExpenses'] as List).map((e) {
        return Expense.fromJson(e as Map<String, dynamic>);
      }).toList();

      final plannedExpenses = (data['plannedExpenses'] as List).map((e) {
        e['endDate'] ??= '';
        return Expense.fromJson(e as Map<String, dynamic>);
      }).toList();

      final unplannedIncomes = (data['unplannedIncomes'] as List).map((e) {
        return Income.fromJson(e as Map<String, dynamic>);
      }).toList();

      final plannedIncomes = (data['plannedIncomes'] as List).map((e) {
        e['endDate'] ??= '';
        return Income.fromJson(e as Map<String, dynamic>);
      }).toList();

      return Budget(
        userId,
        configuration,
        plannedExpenses,
        plannedIncomes,
        unplannedExpenses,
        unplannedIncomes,
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<String>> getPeriods(String token) async {
    try {
      return await dataProvider.getPeriods(token);
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> addBudget({
    required String token,
    required String start,
    required String period,
    required double accountBalance,
  }) async {
    try {
      return await dataProvider.addBudget(
        token: token,
        start: start,
        period: period,
        accountBalance: accountBalance,
      );
    } catch (e) {
      print(e);
      return false;
    }
  }
}
