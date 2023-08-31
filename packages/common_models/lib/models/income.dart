import 'package:common_models/common_models.dart';
import 'package:equatable/equatable.dart';

class Income extends Equatable implements FinanceEntry {
  const Income(
    this.id,
    this.amount,
    this.date,
    this.category,
    this.frequency,
    this.isEnding,
    this.endDate,
    this.isFixed,
    this.userId,
    this.isPlanned,
  );

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

  static const empty = Income('', 0, '', '', '', false, '', false, '', false);
}
