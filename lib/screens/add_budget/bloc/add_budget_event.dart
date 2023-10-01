part of 'add_budget_bloc.dart';

sealed class AddBudgetEvent extends Equatable {
  const AddBudgetEvent();

  @override
  List<Object> get props => [];
}

final class AddBudgetConfigEvent extends AddBudgetEvent {
  const AddBudgetConfigEvent({
    required this.token,
  });

  final String token;

  @override
  List<Object> get props => [
        token,
      ];
}

final class EvaluateBudgetsEvent extends AddBudgetEvent {
  const EvaluateBudgetsEvent({
    required this.token,
  });

  final String token;

  @override
  List<Object> get props => [
        token,
      ];
}

final class AddPeriodChanged extends AddBudgetEvent {
  const AddPeriodChanged({
    required this.period,
  });

  final String period;

  @override
  List<Object> get props => [period];
}

final class AddStartDateChanged extends AddBudgetEvent {
  const AddStartDateChanged({
    required this.startDate,
  });

  final String startDate;

  @override
  List<Object> get props => [startDate];
}

final class AddStartAccountBalanceChanged extends AddBudgetEvent {
  const AddStartAccountBalanceChanged({
    required this.startAccountBalance,
  });

  final double startAccountBalance;

  @override
  List<Object> get props => [startAccountBalance];
}
