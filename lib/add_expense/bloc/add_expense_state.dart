part of 'add_expense_bloc.dart';

final class AddExpenseState extends Equatable {
  const AddExpenseState();

  @override
  List<Object> get props => [];
}

final class CategoriesFetchedState extends AddExpenseState {
  const CategoriesFetchedState({
    required this.categories,
  });

  final List<Category?> categories;

  @override
  List<Object> get props => [categories];
}

final class FrequenciesFetchedState extends AddExpenseState {
  const FrequenciesFetchedState({
    required this.frequencies,
  });

  final List<Frequency?> frequencies;

  @override
  List<Object> get props => [frequencies];
}
