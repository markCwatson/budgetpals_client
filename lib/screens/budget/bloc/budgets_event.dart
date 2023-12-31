part of 'budgets_bloc.dart';

sealed class BudgetsEvent extends Equatable {
  const BudgetsEvent();

  @override
  List<Object> get props => [];
}

class GetExpensesEvent extends BudgetsEvent {
  const GetExpensesEvent({
    required this.token,
  });

  final String token;

  @override
  List<Object> get props => [token];
}

class GetIncomesEvent extends BudgetsEvent {
  const GetIncomesEvent({
    required this.token,
  });

  final String token;

  @override
  List<Object> get props => [token];
}

class GetBudgetEvent extends BudgetsEvent {
  const GetBudgetEvent({
    required this.token,
  });

  final String token;

  @override
  List<Object> get props => [token];
}

class SetTokenEvent extends BudgetsEvent {
  const SetTokenEvent({
    required this.token,
  });

  final String token;

  @override
  List<Object> get props => [token];
}

class CacheResetEvent extends BudgetsEvent {
  const CacheResetEvent();
}

class AddExpenseRequestEvent extends BudgetsEvent {
  const AddExpenseRequestEvent();
}

class AddIncomeRequestEvent extends BudgetsEvent {
  const AddIncomeRequestEvent();
}

class AddExpenseDefinedEvent extends BudgetsEvent {
  const AddExpenseDefinedEvent({
    required this.expense,
  });

  final Expense expense;

  @override
  List<Object> get props => [expense];
}

class DeleteExpenseRequestEvent extends BudgetsEvent {
  const DeleteExpenseRequestEvent({
    required this.token,
    required this.id,
  });

  final String token;
  final String id;

  @override
  List<Object> get props => [token, id];
}

class DeleteIncomeRequestEvent extends BudgetsEvent {
  const DeleteIncomeRequestEvent({
    required this.token,
    required this.id,
  });

  final String token;
  final String id;

  @override
  List<Object> get props => [token, id];
}

class DeletePlannedExpenseRequestEvent extends BudgetsEvent {
  const DeletePlannedExpenseRequestEvent({
    required this.token,
    required this.id,
  });

  final String token;
  final String id;

  @override
  List<Object> get props => [token, id];
}

class DeletePlannedIncomeRequestEvent extends BudgetsEvent {
  const DeletePlannedIncomeRequestEvent({
    required this.token,
    required this.id,
  });

  final String token;
  final String id;

  @override
  List<Object> get props => [token, id];
}
