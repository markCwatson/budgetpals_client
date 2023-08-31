part of 'budgets_bloc.dart';

class BudgetsState extends Equatable {
  const BudgetsState({
    this.token = '',
    this.configuration = Configuration.empty,
    this.plannedExpenses = const [],
    this.plannedIncomes = const [],
    this.unplannedExpenses = const [],
    this.unplannedIncomes = const [],
    this.endAccountBalance = 0,
    // \todo: add loading state
  });

  const BudgetsState.tokenSet(String token) : this(token: token);

  const BudgetsState.expensesLoaded(List<Expense?> expenses)
      : this(unplannedExpenses: expenses);

  const BudgetsState.incomesLoaded(List<Income?> incomes)
      : this(unplannedIncomes: incomes);

  const BudgetsState.budgetLoaded(
    double endAccountBalance,
    Configuration configuration,
    List<Expense?> expenses,
    List<Income?> incomes,
  ) : this(
          endAccountBalance: endAccountBalance,
          configuration: configuration,
          plannedExpenses: expenses,
          plannedIncomes: incomes,
        );

  final String token;
  final Configuration configuration;
  final List<Expense?> plannedExpenses;
  final List<Income?> plannedIncomes;
  final List<Expense?> unplannedExpenses;
  final List<Income?> unplannedIncomes;
  final double endAccountBalance;

  @override
  List<Object> get props => [
        token,
        configuration,
        plannedExpenses,
        plannedIncomes,
        unplannedExpenses,
        unplannedIncomes,
      ];

  String get authToken => token;
}

final class BudgetsInitial extends BudgetsState {}
