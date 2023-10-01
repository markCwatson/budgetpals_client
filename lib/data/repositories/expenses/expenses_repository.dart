import 'dart:async';

import 'package:budgetpals_client/data/providers/expenses/expenses_provider.dart';
import 'package:budgetpals_client/data/repositories/common_models/expense.dart';
import 'package:budgetpals_client/data/repositories/expenses/models/category.dart';
import 'package:budgetpals_client/data/repositories/expenses/models/expense_box.dart';
import 'package:budgetpals_client/data/repositories/expenses/models/frequency.dart';
import 'package:budgetpals_client/data/repositories/irepository.dart';

class ExpensesRepository implements IRepository<Expense> {
  ExpensesRepository({
    required this.dataProvider,
    required this.cache,
  });

  final ExpensesDataProvider dataProvider;

  final IRepository<ExpenseBox> cache;

  @override
  Future<List<Expense?>> get({required String token}) async {
    final cachedExpenses = await cache.get(token: token);

    if (cachedExpenses.isNotEmpty) {
      final items = <Expense>[];
      for (final cachedExpense in cachedExpenses) {
        items.add(cachedExpense!.toExpense());
      }
      return items;
    }

    try {
      final data = await dataProvider.getExpenses(token);

      final expenses = data.map(
        (e) {
          // endDate may not exist
          // \todo: come up with a different approach for this
          e['endDate'] ??= '';

          return Expense.fromJson(e);
        },
      ).toList();

      for (final expense in expenses) {
        print(expense);
        await cache.add(object: expense.toExpenseBox(), token: token);
      }

      return expenses;
    } catch (e) {
      print(e);
      throw Exception('Error fetching expenses');
    }
  }

  @override
  Future<Expense?> getById({required String token, required String id}) async {
    try {
      final data = await dataProvider.getExpenseById(token, id);

      return Expense.fromJson(data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<void> add({
    required Expense object,
    required String token,
  }) async {
    try {
      await dataProvider.addExpense(
        token: token,
        amount: object.amount,
        date: object.date,
        category: object.category,
        frequency: object.frequency,
        isEnding: object.isEnding,
        endDate: object.endDate,
        isFixed: object.isFixed,
        isPlanned: object.isPlanned,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> update({
    required String token,
    required String id,
    required Expense object,
  }) async {
    try {
      await dataProvider.updateExpense(
        token: token,
        id: id,
        amount: object.amount,
        date: object.date,
        category: object.category,
        frequency: object.frequency,
        isEnding: object.isEnding,
        endDate: object.endDate,
        isFixed: object.isFixed,
        isPlanned: object.isPlanned,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> delete({
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
}
