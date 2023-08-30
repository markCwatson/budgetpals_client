import 'package:common_models/common_models.dart';
import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  const Budget(
    this.plannedExpenses,
    this.plannedIncomes,
  );

  final List<Expense> plannedExpenses;
  final List<Income> plannedIncomes;

  @override
  List<Object> get props => [
        plannedExpenses,
        plannedIncomes,
      ];

  static const empty = Budget([], []);
}
