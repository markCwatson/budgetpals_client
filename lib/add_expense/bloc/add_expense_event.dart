part of 'add_expense_bloc.dart';

sealed class AddExpenseEvent extends Equatable {
  const AddExpenseEvent();

  @override
  List<Object> get props => [];
}

final class FetchCategoriesAndFrequenciesEvent extends AddExpenseEvent {
  const FetchCategoriesAndFrequenciesEvent({
    required this.token,
  });

  final String token;

  @override
  List<Object> get props => [token];
}

final class AddExpenseAmountChanged extends AddExpenseEvent {
  const AddExpenseAmountChanged({
    required this.amount,
  });

  final double amount;

  @override
  List<Object> get props => [amount];
}

final class AddExpenseCategoryChanged extends AddExpenseEvent {
  const AddExpenseCategoryChanged({
    required this.category,
  });

  final String category;

  @override
  List<Object> get props => [category];
}

final class AddExpenseFrequencyChanged extends AddExpenseEvent {
  const AddExpenseFrequencyChanged({
    required this.frequency,
  });

  final String frequency;

  @override
  List<Object> get props => [frequency];
}

final class AddExpenseIsFixedChanged extends AddExpenseEvent {
  const AddExpenseIsFixedChanged({
    required this.isFixed,
  });

  final bool isFixed;

  @override
  List<Object> get props => [isFixed];
}

final class AddExpenseIsEndingChanged extends AddExpenseEvent {
  const AddExpenseIsEndingChanged({
    required this.isEnding,
  });

  final bool isEnding;

  @override
  List<Object> get props => [isEnding];
}

final class AddExpenseEndDateChanged extends AddExpenseEvent {
  const AddExpenseEndDateChanged({
    required this.endDate,
  });

  final String endDate;

  @override
  List<Object> get props => [endDate];
}

final class AddExpenseDateChanged extends AddExpenseEvent {
  const AddExpenseDateChanged({
    required this.date,
  });

  final String date;

  @override
  List<Object> get props => [date];
}

final class AddExpenseSubmitted extends AddExpenseEvent {
  const AddExpenseSubmitted({
    required this.token,
    required this.isPlanned,
  });

  final String token;
  final bool isPlanned;

  @override
  List<Object> get props => [token, isPlanned];
}
