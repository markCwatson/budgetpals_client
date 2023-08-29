import 'package:equatable/equatable.dart';

class Income extends Equatable {
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

  final String id;
  final double amount;
  final String date;
  final String category;
  final String frequency;
  final bool isEnding;
  final String endDate;
  final bool isFixed;
  final String userId;
  final bool isPlanned;

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

  static const empty = Income(
    '',
    0,
    '',
    '',
    '',
    false,
    '',
    false,
    '',
    false,
  );
}
