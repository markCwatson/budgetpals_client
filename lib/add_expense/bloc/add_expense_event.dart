part of 'add_expense_bloc.dart';

sealed class AddExpenseEvent extends Equatable {
  const AddExpenseEvent();

  @override
  List<Object> get props => [];
}

final class FetchCategoriesEvent extends AddExpenseEvent {
  const FetchCategoriesEvent({
    required this.token,
  });

  final String token;

  @override
  List<Object> get props => [token];
}

final class FetchFrequenciesEvent extends AddExpenseEvent {}
