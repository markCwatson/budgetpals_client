part of 'budgets_bloc.dart';

sealed class BudgetsEvent extends Equatable {
  const BudgetsEvent();

  @override
  List<Object> get props => [];
}

class GetExpensesEvent extends BudgetsEvent {
  const GetExpensesEvent();
}

class GetIncomesEvent extends BudgetsEvent {
  const GetIncomesEvent();
}

class GetBudgetEvent extends BudgetsEvent {
  const GetBudgetEvent();
}

class SetTokenEvent extends BudgetsEvent {
  const SetTokenEvent({
    required this.token,
  });

  final String token;

  @override
  List<Object> get props => [token];
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
