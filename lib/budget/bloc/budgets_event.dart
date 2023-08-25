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
