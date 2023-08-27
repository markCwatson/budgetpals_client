part of 'add_income_bloc.dart';

sealed class AddIncomeEvent extends Equatable {
  const AddIncomeEvent();

  @override
  List<Object> get props => [];
}

final class FetchCategoriesAndFrequenciesEvent extends AddIncomeEvent {
  const FetchCategoriesAndFrequenciesEvent({
    required this.token,
  });

  final String token;

  @override
  List<Object> get props => [token];
}

final class AddIncomeAmountChanged extends AddIncomeEvent {
  const AddIncomeAmountChanged({
    required this.amount,
  });

  final double amount;

  @override
  List<Object> get props => [amount];
}

final class AddIncomeCategoryChanged extends AddIncomeEvent {
  const AddIncomeCategoryChanged({
    required this.category,
  });

  final String category;

  @override
  List<Object> get props => [category];
}

final class AddIncomeFrequencyChanged extends AddIncomeEvent {
  const AddIncomeFrequencyChanged({
    required this.frequency,
  });

  final String frequency;

  @override
  List<Object> get props => [frequency];
}

final class AddIncomeIsFixedChanged extends AddIncomeEvent {
  const AddIncomeIsFixedChanged({
    required this.isFixed,
  });

  final bool isFixed;

  @override
  List<Object> get props => [isFixed];
}

final class AddIncomeIsEndingChanged extends AddIncomeEvent {
  const AddIncomeIsEndingChanged({
    required this.isEnding,
  });

  final bool isEnding;

  @override
  List<Object> get props => [isEnding];
}

final class AddIncomeEndDateChanged extends AddIncomeEvent {
  const AddIncomeEndDateChanged({
    required this.endDate,
  });

  final String endDate;

  @override
  List<Object> get props => [endDate];
}

final class AddIncomeDateChanged extends AddIncomeEvent {
  const AddIncomeDateChanged({
    required this.date,
  });

  final String date;

  @override
  List<Object> get props => [date];
}

final class AddIncomeSubmitted extends AddIncomeEvent {
  const AddIncomeSubmitted({
    required this.token,
  });

  final String token;

  @override
  List<Object> get props => [token];
}
