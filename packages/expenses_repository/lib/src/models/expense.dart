import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  const Expense(
    this.id,
    this.amount,
    this.category,
    this.frequency,
    this.isEnding,
    this.endDate,
    this.isFixed,
    this.userId,
  );

  final String id;
  final double amount;
  final String category;
  final String frequency;
  final bool isEnding;
  final String endDate;
  final bool isFixed;
  final String userId;

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
      ];

  static const empty = Expense(
    '',
    0,
    '',
    '',
    false,
    '',
    false,
    '',
  );
}
