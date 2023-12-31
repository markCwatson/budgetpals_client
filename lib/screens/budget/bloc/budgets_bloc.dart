import 'package:bloc/bloc.dart';
import 'package:budgetpals_client/data/repositories/budgets/budgets_repository.dart';
import 'package:budgetpals_client/data/repositories/budgets/models/budget.dart';
import 'package:budgetpals_client/data/repositories/budgets/models/configuration.dart';
import 'package:budgetpals_client/data/repositories/common_models/expense.dart';
import 'package:budgetpals_client/data/repositories/common_models/generic.dart';
import 'package:budgetpals_client/data/repositories/common_models/income.dart';
import 'package:budgetpals_client/data/repositories/expenses/expenses_repository.dart';
import 'package:budgetpals_client/data/repositories/incomes/incomes_repository.dart';
import 'package:budgetpals_client/screens/budget/bloc/utilities/utilities.dart';
import 'package:equatable/equatable.dart';

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
    on<CacheResetEvent>(_onCacheResetEvent);
  }

  final ExpensesRepository _expensesRepository;
  final IncomesRepository _incomesRepository;
  final BudgetsRepository _budgetsRepository;

  Future<void> _onGetBudgetEvent(
    GetBudgetEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    final budget = await _budgetsRepository.get(token: event.token);
    if (budget.isEmpty) return;

    _recalculateAndEmit(budget[0]!, emit);
  }

  Future<void> _onCacheResetEvent(
    CacheResetEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    await _budgetsRepository.clearCache();
  }

  Future<void> _onDeletePlannedExpenseEvent(
    DeletePlannedExpenseRequestEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    try {
      await _expensesRepository.delete(
        token: event.token,
        id: event.id,
      );

      final budget = await _budgetsRepository.get(token: event.token);
      if (budget.isEmpty) return;

      _recalculateAndEmit(budget[0]!, emit);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onDeletePlannedIncomeEvent(
    DeletePlannedIncomeRequestEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    try {
      await _incomesRepository.delete(
        token: event.token,
        id: event.id,
      );

      final budget = await _budgetsRepository.get(token: event.token);
      if (budget.isEmpty) return;

      _recalculateAndEmit(budget[0]!, emit);
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
      final expenses = await _expensesRepository.get(token: event.token);

      // filter by expenses in this period
      final expensesInThisPeriod = _getItemsInThisPeriod(
        expenses as List<FinanceEntry>,
        state.configuration,
      ) as List<Expense>;

      emit(BudgetsState.expensesLoaded(expensesInThisPeriod));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onGetIncomesEvent(
    GetIncomesEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    try {
      final incomes = await _incomesRepository.get(token: event.token);

      // filter by incomes in this period
      final incomesInThisPeriod = _getItemsInThisPeriod(
        incomes as List<FinanceEntry>,
        state.configuration,
      ) as List<Income>;

      emit(BudgetsState.incomesLoaded(incomesInThisPeriod));
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
      await _expensesRepository.delete(
        token: event.token,
        id: event.id,
      );
      final expenses = await _expensesRepository.get(token: event.token);
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
      await _incomesRepository.delete(
        token: event.token,
        id: event.id,
      );
      final incomes = await _incomesRepository.get(token: event.token);
      emit(BudgetsState.incomesLoaded(incomes));
    } catch (e) {
      print(e);
    }
  }

  void _recalculateAndEmit(
    Budget budget,
    Emitter<BudgetsState> emit,
  ) {
    // Compute the total planned expenses and incomes for the current period
    final totalPlannedExpenses = _computeTotalItems(
      items: budget.plannedExpenses,
      configuration: budget.configuration,
    );

    final totalPlannedIncomes = _computeTotalItems(
      items: budget.plannedIncomes,
      configuration: budget.configuration,
    );

    final endAccountBalance = budget.configuration.startAccountBalance +
        totalPlannedIncomes -
        totalPlannedExpenses;

    // compute the actual expenses and incomes for the current period
    final totalUnplannedExpenses = _computeTotalItems(
      items: budget.unplannedExpenses,
      configuration: budget.configuration,
    );

    final totalUnplannedIncomes = _computeTotalItems(
      items: budget.unplannedIncomes,
      configuration: budget.configuration,
    );

    final adjustedEndAccountBalance = endAccountBalance +
        totalUnplannedIncomes -
        totalPlannedIncomes +
        totalPlannedExpenses -
        totalUnplannedExpenses;

    // limit income/expense to current period
    final plannedIncomes = _getItemsInThisPeriod(
      budget.plannedIncomes,
      budget.configuration,
    ) as List<Income>;

    final plannedExpenses = _getItemsInThisPeriod(
      budget.plannedExpenses,
      budget.configuration,
    ) as List<Expense>;

    emit(
      BudgetsState.budgetLoaded(
        endAccountBalance,
        budget.configuration,
        plannedExpenses,
        plannedIncomes,
        _getCurrentPeriod(budget.configuration),
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
    Configuration configuration,
  ) {
    final currentPeriod = _getCurrentPeriod(configuration);
    final later = currentPeriod.end!.add(const Duration(days: 1));
    final itemsInThisPeriod = items.where((element) {
      return DateTime.parse(element.date).isBefore(later) &&
          DateTime.parse(element.date).isAfter(currentPeriod.start!);
    }).toList();
    return itemsInThisPeriod;
  }

  BudgetPeriod _getCurrentPeriod(Configuration configuration) {
    final createdAt = DateTime.parse(configuration.startDate);
    final today = DateTime.now().toUtc();
    final currentPeriod = const PeriodCalculator().calculateCurrentPeriod(
      createdAt,
      configuration.period,
      today,
    );
    return currentPeriod;
  }

  double _computeTotalItems({
    required List<FinanceEntry> items,
    required Configuration configuration,
  }) {
    final createdAt = DateTime.parse(configuration.startDate);
    final today = DateTime.now().toUtc();
    final currentPeriod = const PeriodCalculator().calculateCurrentPeriod(
      createdAt,
      configuration.period,
      today,
    );

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
