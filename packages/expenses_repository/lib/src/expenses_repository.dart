import 'dart:async';

import 'package:api/api.dart';
import 'package:expenses_repository/src/models/models.dart';

class ExpensesRepository {
  ExpensesRepository({required this.dataProvider});

  final ExpensesDataProvider dataProvider;

  Future<List<Expense?>> getExpenses(String token) async {
    try {
      final data = await dataProvider.getExpenses(token);

      return data
          .map(
            (e) => Expense(
              e['_id'] as String,
              e['amount'] as int,
              e['category'] as String,
              e['frequency'] as String,
              e['isEnding'] as bool,
              e['endDate'] as String,
              e['isFixed'] as bool,
              e['userId'] as String,
            ),
          )
          .toList();
    } catch (e) {
      print(e);
      return List.empty();
    }
  }
}
