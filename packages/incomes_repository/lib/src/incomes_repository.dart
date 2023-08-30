import 'dart:async';

import 'package:api/api.dart';
import 'package:common_models/common_models.dart';
import 'package:incomes_repository/src/models/models.dart';

class IncomesRepository {
  IncomesRepository({required this.dataProvider});

  final IncomesDataProvider dataProvider;

  Future<List<Income?>> getIncomes(String token) async {
    try {
      final data = await dataProvider.getIncomes(token);

      return data.map(
        (e) {
          // endDate may not exist
          // \todo: come up with a different approach for this
          e['endDate'] ??= '';

          return Income.fromJson(e);
        },
      ).toList();
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  Future<List<Category?>> getIncomeCategories(String token) async {
    try {
      final data = await dataProvider.getIncomeCategories(token);

      // ignore: unnecessary_lambdas
      return data.map((str) => Category(str)).toList();
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  Future<List<Frequency?>> getIncomeFrequencies(String token) async {
    try {
      final data = await dataProvider.getIncomeFrequencies(token);
      // ignore: unnecessary_lambdas
      return data.map((str) => Frequency(str)).toList();
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  Future<void> addIncome({
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
      await dataProvider.addIncome(
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

  Future<void> deleteIncome({
    required String token,
    required String id,
  }) async {
    try {
      await dataProvider.deleteIncome(
        token: token,
        id: id,
      );
    } catch (e) {
      print(e);
    }
  }
}
