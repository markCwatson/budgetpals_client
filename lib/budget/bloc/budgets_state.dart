part of 'budgets_bloc.dart';

class BudgetsState extends Equatable {
  const BudgetsState({
    this.token = '',
    this.expenses = const [],
    // \todo: add loading state
    // \todo: add incomes
  });

  const BudgetsState.tokenSet(String token) : this(token: token);

  const BudgetsState.expensesLoaded(List<Expense?> expenses)
      : this(expenses: expenses);

  final String token;
  final List<Expense?> expenses;

  @override
  List<Object> get props => [token, expenses];

  String get authToken => token;
}

final class BudgetsInitial extends BudgetsState {}

final class BudgetGoToAddExpense extends BudgetsState {}

final class BudgetGoToAddIncome extends BudgetsState {}
