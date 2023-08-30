part of 'budgets_bloc.dart';

class BudgetsState extends Equatable {
  const BudgetsState({
    this.token = '',
    this.expenses = const [],
    this.incomes = const [],
    this.plannedExpenses = const [],
    this.plannedIncomes = const [],
    // \todo: add loading state
  });

  const BudgetsState.tokenSet(String token) : this(token: token);

  const BudgetsState.expensesLoaded(List<Expense?> expenses)
      : this(expenses: expenses);

  const BudgetsState.incomesLoaded(List<Income?> incomes)
      : this(incomes: incomes);

  const BudgetsState.budgetLoaded(
    List<Expense?> expenses,
    List<Income?> incomes,
  ) : this(
          plannedExpenses: expenses,
          plannedIncomes: incomes,
        );

  final String token;
  final List<Expense?> expenses;
  final List<Income?> incomes;
  final List<Expense?> plannedExpenses;
  final List<Income?> plannedIncomes;

  @override
  List<Object> get props => [
        token,
        expenses,
        incomes,
        plannedExpenses,
        plannedIncomes,
      ];

  String get authToken => token;
}

final class BudgetsInitial extends BudgetsState {}
