part of 'add_budget_bloc.dart';

final class AddBudgetState extends Equatable {
  const AddBudgetState({
    this.status = FormzSubmissionStatus.initial,
    this.startDate = const Date.pure(),
    this.period = const Period.pure(),
    this.startAccountBalance = const Amount.pure(),
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final Period period;
  final Date startDate;
  final Amount startAccountBalance;
  final bool isValid;

  AddBudgetState copyWith({
    FormzSubmissionStatus? status,
    Period? period,
    Date? startDate,
    Amount? startAccountBalance,
    bool? isValid,
  }) {
    return AddBudgetState(
      status: status ?? this.status,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      startAccountBalance: startAccountBalance ?? this.startAccountBalance,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [
        status,
        period,
        startDate,
        startAccountBalance,
        isValid,
      ];
}

final class BudgetExists extends AddBudgetState {}

final class AddBudgetInitial extends AddBudgetState {}

final class AddBudgetSuccess extends AddBudgetState {}

final class AddBudgetFailed extends AddBudgetState {}

final class GetBudgetPeriodsSuccess extends AddBudgetState {
  const GetBudgetPeriodsSuccess({
    required this.periods,
  });

  final List<Frequency?> periods;

  @override
  List<Object> get props => [
        periods,
      ];
}
