import 'package:bloc/bloc.dart';
import 'package:budgetpals_client/budget/bloc/utilities/utilities.dart';
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

    _recalculateAndEmit(budget, emit);
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

      _recalculateAndEmit(budget, emit);
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

      _recalculateAndEmit(budget, emit);
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

  void _recalculateAndEmit(
    Budget budget,
    Emitter<BudgetsState> emit,
  ) {
    // Compute the start and end of the current period
    final createdAt = DateTime.parse(budget.configuration.startDate);
    final today = DateTime.now().toUtc();
    final currentPeriod = const PeriodCalculator().calculateCurrentPeriod(
      createdAt,
      budget.configuration.period,
      today,
    );

    // Compute the total planned expenses and incomes for the current period
    final totalPlannedExpenses = _computeTotalItems(
      items: budget.plannedExpenses,
      currentPeriod: currentPeriod,
    );

    final totalPlannedIncomes = _computeTotalItems(
      items: budget.plannedIncomes,
      currentPeriod: currentPeriod,
    );

    final endAccountBalance = budget.configuration.startAccountBalance +
        totalPlannedIncomes -
        totalPlannedExpenses;

    // compute the actual expenses and incomes for the current period
    final totalUnplannedExpenses = _computeTotalItems(
      items: budget.unplannedExpenses,
      currentPeriod: currentPeriod,
    );

    final totalUnplannedIncomes = _computeTotalItems(
      items: budget.unplannedIncomes,
      currentPeriod: currentPeriod,
    );

    final adjustedEndAccountBalance = endAccountBalance +
        totalUnplannedIncomes -
        totalPlannedIncomes +
        totalPlannedExpenses -
        totalUnplannedExpenses;

    // limit income/expense to current period
    final plannedIncomes = _getItemsInThisPeriod(
      budget.plannedIncomes,
      currentPeriod,
    ) as List<Income>;

    final plannedExpenses = _getItemsInThisPeriod(
      budget.plannedExpenses,
      currentPeriod,
    ) as List<Expense>;

    emit(
      BudgetsState.budgetLoaded(
        endAccountBalance,
        budget.configuration,
        plannedExpenses,
        plannedIncomes,
        currentPeriod,
        totalPlannedExpenses,
        totalPlannedIncomes,
        totalUnplannedExpenses,
        totalUnplannedIncomes,
        adjustedEndAccountBalance,
      ),
    );
  }

  List<FinanceEntry> _getItemsInThisPeriod(
    List<FinanceEntry> items,
    BudgetPeriod currentPeriod,
  ) {
    final later = currentPeriod.end!.add(const Duration(days: 1));
    final itemsInThisPeriod = items.where((element) {
      return DateTime.parse(element.date).isBefore(later) &&
          DateTime.parse(element.date).isAfter(currentPeriod.start!);
    }).toList();
    return itemsInThisPeriod;
  }

  double _computeTotalItems({
    required List<FinanceEntry> items,
    required BudgetPeriod currentPeriod,
  }) {
    final later = currentPeriod.end!.add(const Duration(days: 1));
    return items.fold<double>(
      0,
      (previousValue, element) {
        final date = DateTime.parse(element.date);
        if (date.isAfter(currentPeriod.start!) && date.isBefore(later)) {
          return previousValue + element.amount;
        }
        return previousValue;
      },
    );
  }
}
