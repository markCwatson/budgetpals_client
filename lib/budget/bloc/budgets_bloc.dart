import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_repository/expenses_repository.dart';

part 'budgets_event.dart';
part 'budgets_state.dart';

class BudgetsBloc extends Bloc<BudgetsEvent, BudgetsState> {
  BudgetsBloc({
    required ExpensesRepository expensesRepository,
  })  : _expensesRepository = expensesRepository,
        super(BudgetsInitial()) {
    on<GetBudgetEvent>(_onGetBudgetEvent);
    on<GetExpensesEvent>(_onGetExpensesEvent);
    on<GetIncomesEvent>(_onGetIncomesEvent);
    on<SetTokenEvent>(_onSetTokenEvent);
    on<AddExpenseRequestEvent>(_onAddExpenseRequestEvent);
    on<AddIncomeRequestEvent>(_onAddIncomeRequestEvent);
  }

  final ExpensesRepository _expensesRepository;

  Future<void> _onGetBudgetEvent(
    GetBudgetEvent event,
    Emitter<BudgetsState> emit,
  ) async {}

  Future<void> _onGetExpensesEvent(
    GetExpensesEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    try {
      final expenses = await _expensesRepository.getExpenses(state.authToken);
      emit(BudgetsState.expensesLoaded(expenses));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onGetIncomesEvent(
    GetIncomesEvent event,
    Emitter<BudgetsState> emit,
  ) async {}

  Future<void> _onSetTokenEvent(
    SetTokenEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    emit(BudgetsState.tokenSet(event.token));
  }

  Future<void> _onAddExpenseRequestEvent(
    AddExpenseRequestEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    emit(BudgetGoToAddExpense());
  }

  Future<void> _onAddIncomeRequestEvent(
    AddIncomeRequestEvent event,
    Emitter<BudgetsState> emit,
  ) async {
    emit(BudgetGoToAddIncome());
  }
}
