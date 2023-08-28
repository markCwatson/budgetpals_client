part of 'budgets_bloc.dart';

class BudgetsState extends Equatable {
  const BudgetsState({
    this.token = '',
    this.expenses = const [],
    this.incomes = const [],
    // \todo: add loading state
  });

  const BudgetsState.tokenSet(String token) : this(token: token);

  const BudgetsState.expensesLoaded(List<Expense?> expenses)
      : this(expenses: expenses);

  const BudgetsState.incomesLoaded(List<Income?> incomes)
      : this(incomes: incomes);

  final String token;
  final List<Expense?> expenses;
  final List<Income?> incomes;

  @override
  List<Object> get props => [token, expenses, incomes];

  String get authToken => token;
}

final class BudgetsInitial extends BudgetsState {}
