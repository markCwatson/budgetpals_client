part of 'budgets_bloc.dart';

class BudgetsState extends Equatable {
  const BudgetsState({
    this.token = '',
    this.configuration = Configuration.empty,
    this.plannedExpenses = const [],
    this.plannedIncomes = const [],
    this.unplannedExpenses = const [],
    this.unplannedIncomes = const [],
    this.currentPeriod = BudgetPeriod.empty,
    this.endAccountBalance = 0,
    this.totalPlannedExpenses = 0,
    this.totalPlannedIncomes = 0,
    this.totalUnplannedExpenses = 0,
    this.totalUnplannedIncomes = 0,
    this.adjustedEndAccountBalance = 0,
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
    BudgetPeriod currentPeriod,
    double totalPlannedExpenses,
    double totalPlannedIncomes,
    double totalUnplannedExpenses,
    double totalUnplannedIncomes,
    double adjustedEndAccountBalance,
  ) : this(
          endAccountBalance: endAccountBalance,
          configuration: configuration,
          plannedExpenses: expenses,
          plannedIncomes: incomes,
          currentPeriod: currentPeriod,
          totalPlannedExpenses: totalPlannedExpenses,
          totalPlannedIncomes: totalPlannedIncomes,
          totalUnplannedExpenses: totalUnplannedExpenses,
          totalUnplannedIncomes: totalUnplannedIncomes,
          adjustedEndAccountBalance: adjustedEndAccountBalance,
        );

  final String token;
  final Configuration configuration;
  final List<Expense?> plannedExpenses;
  final List<Income?> plannedIncomes;
  final List<Expense?> unplannedExpenses;
  final List<Income?> unplannedIncomes;
  final double endAccountBalance;
  final BudgetPeriod currentPeriod;
  final double totalPlannedExpenses;
  final double totalPlannedIncomes;
  final double totalUnplannedExpenses;
  final double totalUnplannedIncomes;
  final double adjustedEndAccountBalance;

  @override
  List<Object> get props => [
        token,
        configuration,
        plannedExpenses,
        plannedIncomes,
        unplannedExpenses,
        unplannedIncomes,
        endAccountBalance,
        currentPeriod,
        totalPlannedExpenses,
        totalPlannedIncomes,
        totalUnplannedExpenses,
        totalUnplannedIncomes,
        adjustedEndAccountBalance,
      ];

  String get authToken => token;
}

final class BudgetsInitial extends BudgetsState {}
