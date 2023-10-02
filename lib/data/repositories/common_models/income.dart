import 'package:budgetpals_client/data/repositories/common_models/generic.dart';
import 'package:budgetpals_client/data/repositories/incomes/boxes/income_box.dart';
import 'package:equatable/equatable.dart';

class Income extends Equatable implements FinanceEntry {
  const Income({
    required this.amount,
    required this.date,
    required this.category,
    this.id = '',
    this.frequency = '',
    this.isEnding = false,
    this.endDate = '',
    this.isFixed = false,
    this.userId = '',
    this.isPlanned = false,
  });

  Income.fromJson(Map<String, dynamic> json)
      : id = (json['_id'] ?? '') as String,
        amount = (json['amount'] ?? 0) as double,
        date = (json['date'] ?? '') as String,
        category = (json['category'] ?? '') as String,
        frequency = (json['frequency'] ?? '') as String,
        isEnding = (json['isEnding'] ?? false) as bool,
        endDate = (json['endDate'] ?? '') as String,
        isFixed = (json['isFixed'] ?? false) as bool,
        userId = (json['userId'] ?? '') as String,
        isPlanned = (json['isPlanned'] ?? false) as bool;

  final String id;
  final String frequency;
  final bool isEnding;
  final String endDate;
  final bool isFixed;
  final String userId;
  final bool isPlanned;

  @override
  final double amount;
  @override
  final String date;
  @override
  final String category;

  @override
  List<Object> get props => [
        id,
        amount,
        category,
        frequency,
        isEnding,
        endDate,
        isFixed,
        userId,
        isPlanned,
      ];

  static const empty = Income(amount: 0, date: '', category: '');

  IncomeBox toIncomeBox() {
    final expenseBox = IncomeBox()
      ..id = id
      ..amount = amount
      ..date = date
      ..category = category
      ..frequency = frequency
      ..isEnding = isEnding
      ..endDate = endDate
      ..isFixed = isFixed
      ..userId = userId
      ..isPlanned = isPlanned;
    return expenseBox;
  }
}
