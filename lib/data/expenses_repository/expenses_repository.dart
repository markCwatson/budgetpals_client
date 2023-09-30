import 'dart:async';

import 'package:budgetpals_client/data/api/src/expenses/expenses_provider.dart';
import 'package:budgetpals_client/data/common_models/expense.dart';
import 'package:budgetpals_client/data/expenses_repository/models/category.dart';
import 'package:budgetpals_client/data/expenses_repository/models/frequency.dart';

class ExpensesRepository {
  ExpensesRepository({required this.dataProvider});

  final ExpensesDataProvider dataProvider;

  Future<List<Expense?>> getExpenses(String token) async {
    try {
      final data = await dataProvider.getExpenses(token);

      return data.map(
        (e) {
          // endDate may not exist
          // \todo: come up with a different approach for this
          e['endDate'] ??= '';

          return Expense.fromJson(e);
        },
      ).toList();
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  Future<Expense?> getExpenseById(String token, String id) async {
    try {
      final data = await dataProvider.getExpenseById(token, id);

      return Expense.fromJson(data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Category?>> getExpenseCategories(String token) async {
    try {
      final data = await dataProvider.getExpenseCategories(token);

      // ignore: unnecessary_lambdas
      return data.map((str) => Category(str)).toList();
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  Future<List<Frequency?>> getExpenseFrequencies(String token) async {
    try {
      final data = await dataProvider.getExpenseFrequencies(token);
      // ignore: unnecessary_lambdas
      return data.map((str) => Frequency(str)).toList();
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  Future<void> addExpense({
    required String token,
    required double amount,
    required String date,
    required String category,
    required String frequency,
    required bool isEnding,
    required String endDate,
    required bool isFixed,
    required bool isPlanned,
  }) async {
    try {
      await dataProvider.addExpense(
        token: token,
        amount: amount,
        date: date,
        category: category,
        frequency: frequency,
        isEnding: isEnding,
        endDate: endDate,
        isFixed: isFixed,
        isPlanned: isPlanned,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteExpense({
    required String token,
    required String id,
  }) async {
    try {
      await dataProvider.deleteExpense(
        token: token,
        id: id,
      );
    } catch (e) {
      print(e);
    }
  }
}
