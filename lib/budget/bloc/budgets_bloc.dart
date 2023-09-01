import 'package:bloc/bloc.dart';
import 'package:budgets_repository/budgets_repository.dart';
import 'package:common_models/common_models.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:incomes_repository/incomes_repository.dart';

part 'budgets_event.dart';
part 'budgets_state.dart';

class BudgetsBloc extends Bloc<BudgetsEvent, BudgetsState> {
  BudgetsBloc({
    required ExpensesRepository expensesRepository,
    required IncomesRepository incomesRepository,
    required BudgetsRepository budgetsRepository,
  })  : _expensesRepository = expensesRepository,
        _incomesRepository = incomesRepository,
        _budgetsRepository = budgetsRepository,
        super(BudgetsInitial()) {
    on<GetBudgetEvent>(_onGetBudgetEvent);
    on<GetExpensesEvent>(_onGetExpensesEvent);
    on<GetIncomesEvent>(_onGetIncomesEvent);
    on<SetTokenEvent>(_onSetTokenEvent);
    on<DeleteExpenseRequestEvent>(_onDeleteExpenseEvent);
    on<DeleteIncomeRequestEvent>(_onDeleteIncomeEvent);
    on<DeletePlannedExpenseRequestEvent>(_onDeletePlannedExpenseEvent);
    on<DeletePlannedIncomeRequestEvent>(_onDeletePlannedIncomeEvent);
  }

  final ExpensesRepository _expensesRepository;
  final IncomesRepository _incomesRepository;
  final BudgetsRepository _budgetsRepository;

  Future<void> _onGetBudgetEvent(
    GetBudgetEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    final budget = await _budgetsRepository.getBudget(event.token);
    if (budget == null) return;

    final endAccountBalance = _computeEndAccountBalance(budget);

    emit(
      BudgetsState.budgetLoaded(
        endAccountBalance,
        budget.configuration,
        budget.plannedExpenses,
        budget.plannedIncomes,
      ),
    );
  }

  Future<void> _onDeletePlannedExpenseEvent(
    DeletePlannedExpenseRequestEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    try {
      await _expensesRepository.deleteExpense(
        token: event.token,
        id: event.id,
      );

      final budget = await _budgetsRepository.getBudget(event.token);
      if (budget == null) return;

      final endAccountBalance = _computeEndAccountBalance(budget);

      emit(
        BudgetsState.budgetLoaded(
          endAccountBalance,
          budget.configuration,
          budget.plannedExpenses,
          budget.plannedIncomes,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onDeletePlannedIncomeEvent(
    DeletePlannedIncomeRequestEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    try {
      await _incomesRepository.deleteIncome(
        token: event.token,
        id: event.id,
      );

      final budget = await _budgetsRepository.getBudget(event.token);
      if (budget == null) return;

      final endAccountBalance = _computeEndAccountBalance(budget);

      emit(
        BudgetsState.budgetLoaded(
          endAccountBalance,
          budget.configuration,
          budget.plannedExpenses,
          budget.plannedIncomes,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onGetExpensesEvent(
    GetExpensesEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    try {
      // \todo: consider using token on event instead of state??
      final expenses = await _expensesRepository.getExpenses(event.token);
      emit(BudgetsState.expensesLoaded(expenses));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onGetIncomesEvent(
    GetIncomesEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    try {
      final incomes = await _incomesRepository.getIncomes(event.token);
      emit(BudgetsState.incomesLoaded(incomes));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onSetTokenEvent(
    SetTokenEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    emit(BudgetsState.tokenSet(event.token));
  }

  Future<void> _onDeleteExpenseEvent(
    DeleteExpenseRequestEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    try {
      await _expensesRepository.deleteExpense(
        token: event.token,
        id: event.id,
      );
      final expenses = await _expensesRepository.getExpenses(event.token);
      emit(BudgetsState.expensesLoaded(expenses));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onDeleteIncomeEvent(
    DeleteIncomeRequestEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    try {
      await _incomesRepository.deleteIncome(
        token: event.token,
        id: event.id,
      );
      final incomes = await _incomesRepository.getIncomes(event.token);
      emit(BudgetsState.incomesLoaded(incomes));
    } catch (e) {
      print(e);
    }
  }

  double _computeEndAccountBalance(Budget budget) {
    final endAccountBalance = budget.configuration.startAccountBalance +
        budget.plannedIncomes.fold<double>(
          0,
          (previousValue, element) => previousValue + element.amount,
        ) -
        budget.plannedExpenses.fold<double>(
          0,
          (previousValue, element) => previousValue + element.amount,
        );
    return endAccountBalance;
  }
}
