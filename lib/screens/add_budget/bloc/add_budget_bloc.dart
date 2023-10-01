import 'package:bloc/bloc.dart';
import 'package:budgetpals_client/data/repositories/budgets/budgets_repository.dart';
import 'package:budgetpals_client/screens/add_budget/models/amount.dart';
import 'package:budgetpals_client/screens/add_budget/models/date.dart';
import 'package:budgetpals_client/screens/add_budget/models/period.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'add_budget_event.dart';
part 'add_budget_state.dart';

class AddBudgetBloc extends Bloc<AddBudgetEvent, AddBudgetState> {
  AddBudgetBloc({
    required BudgetsRepository budgetsRepository,
  })  : _budgetsRepository = budgetsRepository,
        super(AddBudgetInitial()) {
    on<AddBudgetConfigEvent>(_onAddBudgetConfigEvent);
    on<EvaluateBudgetsEvent>(_onEvaluateBudgetsEvent);
    on<AddPeriodChanged>(_onPeriodChanged);
    on<AddStartDateChanged>(_onStartDateChanged);
    on<AddStartAccountBalanceChanged>(_onStartAccountBalanceChanged);
  }

  final BudgetsRepository _budgetsRepository;

  Future<void> _onAddBudgetConfigEvent(
    AddBudgetConfigEvent event,
    Emitter<AddBudgetState> emit,
  ) async {
    final result = await _budgetsRepository.addBudget(
      token: event.token,
      start: state.startDate.value,
      period: state.period.value,
      accountBalance: state.startAccountBalance.value,
    );
    if (result) {
      state.copyWith(status: FormzSubmissionStatus.success);
      emit(AddBudgetSuccess());
      return;
    }

    state.copyWith(status: FormzSubmissionStatus.failure);
    emit(AddBudgetFailed());
  }

  Future<void> _onEvaluateBudgetsEvent(
    EvaluateBudgetsEvent event,
    Emitter<AddBudgetState> emit,
  ) async {
    // first check if this user has a budget
    final budget = await _budgetsRepository.getBudget(event.token);
    if (budget != null) {
      emit(BudgetExists());
      return;
    }

    // no budget exists so get periods and continue configuration
    final periods = await _budgetsRepository.getPeriods(event.token);
    emit(GetBudgetPeriodsSuccess(periods: periods));
  }

  Future<void> _onPeriodChanged(
    AddPeriodChanged event,
    Emitter<AddBudgetState> emit,
  ) async {
    final period = Period.dirty(event.period);
    emit(
      state.copyWith(
        period: period,
        startDate: state.startDate,
        startAccountBalance: state.startAccountBalance,
        isValid: Formz.validate([
          period,
        ]),
      ),
    );
  }

  void _onStartDateChanged(
    AddStartDateChanged event,
    Emitter<AddBudgetState> emit,
  ) {
    final startDate = Date.dirty(event.startDate);
    emit(
      state.copyWith(
        startDate: startDate,
        isValid: Formz.validate([
          state.period,
          startDate,
          state.startAccountBalance,
        ]),
      ),
    );
  }

  void _onStartAccountBalanceChanged(
    AddStartAccountBalanceChanged event,
    Emitter<AddBudgetState> emit,
  ) {
    final startAccountBalance = Amount.dirty(event.startAccountBalance);
    emit(
      state.copyWith(
        startAccountBalance: startAccountBalance,
        isValid: Formz.validate([
          state.period,
          state.startDate,
          startAccountBalance,
        ]),
      ),
    );
  }
}
