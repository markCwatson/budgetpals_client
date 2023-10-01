import 'package:bloc/bloc.dart';
import 'package:budgetpals_client/data/repositories/common_models/expense.dart';
import 'package:budgetpals_client/data/repositories/expenses/expenses_repository.dart';
import 'package:budgetpals_client/data/repositories/expenses/models/category.dart';
import 'package:budgetpals_client/data/repositories/expenses/models/frequency.dart';
import 'package:budgetpals_client/screens/add_expense/models/amount.dart';
import 'package:budgetpals_client/screens/add_expense/models/category_form.dart';
import 'package:budgetpals_client/screens/add_expense/models/date.dart';
import 'package:budgetpals_client/screens/add_expense/models/end_date.dart';
import 'package:budgetpals_client/screens/add_expense/models/frequency_form.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'add_expense_event.dart';
part 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  AddExpenseBloc({
    required ExpensesRepository expensesRepository,
  })  : _expensesRepository = expensesRepository,
        super(const AddExpenseState()) {
    on<FetchCategoriesAndFrequenciesEvent>(
      _onFetchCategoriesAndFrequenciesEvent,
    );
    on<AddExpenseTypeSelected>(_onAddExpenseTypeSelected);
    on<AddExpenseAmountChanged>(_onAmountChanged);
    on<AddExpenseDateChanged>(_onDateChanged);
    on<AddExpenseCategoryChanged>(_onCategoryChanged);
    on<AddExpenseFrequencyChanged>(_onFrequencyChanged);
    on<AddExpenseIsFixedChanged>(_onIsFixedChanged);
    on<AddExpenseIsEndingChanged>(_onIsEndingChanged);
    on<AddExpenseEndDateChanged>(_onEndDateChanged);
    on<AddExpenseSubmitted>(_onAddExpenseSubmitted);
    on<FetchPlannedExpensesEvent>(_onFetchPlannedExpensesEvent);
    on<PlannedExpenseSelected>(_onPlannedExpenseSelected);
  }

  final ExpensesRepository _expensesRepository;

  void _onAddExpenseTypeSelected(
    AddExpenseTypeSelected event,
    Emitter<AddExpenseState> emit,
  ) {
    emit(
      state.copyWith(
        isPlanned: event.isPlanned,
      ),
    );
  }

  void _onAmountChanged(
    AddExpenseAmountChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    final amount = Amount.dirty(event.amount);
    emit(
      state.copyWith(
        amount: amount,
        isValid: Formz.validate([
          amount,
          state.date,
          state.category,
          state.frequency,
          state.endDate,
        ]),
      ),
    );
  }

  void _onDateChanged(
    AddExpenseDateChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    final date = Date.dirty(event.date);
    emit(
      state.copyWith(
        date: date,
        isValid: Formz.validate([
          state.amount,
          date,
          state.category,
          state.frequency,
          state.endDate,
        ]),
      ),
    );
  }

  void _onCategoryChanged(
    AddExpenseCategoryChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    final category = CategoryForm.dirty(event.category);
    emit(
      state.copyWith(
        category: category,
        isValid: Formz.validate([
          state.amount,
          state.date,
          category,
          state.frequency,
          state.endDate,
        ]),
      ),
    );
  }

  void _onFrequencyChanged(
    AddExpenseFrequencyChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    final frequency = FrequencyForm.dirty(event.frequency);
    emit(
      state.copyWith(
        frequency: frequency,
        isValid: Formz.validate([
          state.amount,
          state.date,
          state.category,
          frequency,
          state.endDate,
        ]),
      ),
    );
  }

  void _onEndDateChanged(
    AddExpenseEndDateChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    final endDate = EndDate.dirty(event.endDate);
    emit(
      state.copyWith(
        endDate: endDate,
        isValid: Formz.validate([
          state.amount,
          state.date,
          state.category,
          state.frequency,
          endDate,
        ]),
      ),
    );
  }

  void _onIsFixedChanged(
    AddExpenseIsFixedChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    emit(
      state.copyWith(
        isFixed: event.isFixed,
      ),
    );
  }

  void _onIsEndingChanged(
    AddExpenseIsEndingChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    emit(
      state.copyWith(
        isEnding: event.isEnding,
      ),
    );
  }

  Future<void> _onFetchPlannedExpensesEvent(
    FetchPlannedExpensesEvent event,
    Emitter<AddExpenseState> emit,
  ) async {
    try {
      final expenses = await _expensesRepository.get(token: event.token);
      if (expenses.isEmpty) return;

      final plannedExpenses =
          expenses.where((expense) => expense!.isPlanned).toList();

      // \todo: get items in this period only
      emit(PlannedExpensesFetchedState(plannedExpenses: plannedExpenses));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onPlannedExpenseSelected(
    PlannedExpenseSelected event,
    Emitter<AddExpenseState> emit,
  ) async {
    try {
      final expense = await _expensesRepository.getById(
        token: event.token,
        id: event.plannedExpenseId,
      );

      if (expense == null) return;

      emit(
        state.copyWith(
          amount: Amount.dirty(expense.amount),
          date: Date.dirty(expense.date),
          category: CategoryForm.dirty(expense.category),
          frequency: FrequencyForm.dirty(expense.frequency),
          endDate: EndDate.dirty(expense.endDate),
          isFixed: expense.isFixed,
          isValid: Formz.validate([
            Amount.dirty(expense.amount),
            Date.dirty(expense.date),
            CategoryForm.dirty(expense.category),
            FrequencyForm.dirty(expense.frequency),
            EndDate.dirty(expense.endDate),
          ]),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onFetchCategoriesAndFrequenciesEvent(
    FetchCategoriesAndFrequenciesEvent event,
    Emitter<AddExpenseState> emit,
  ) async {
    try {
      final categories =
          await _expensesRepository.getExpenseCategories(event.token);
      final frequencies =
          await _expensesRepository.getExpenseFrequencies(event.token);

      emit(
        CategoriesAndFrequenciesFetchedState(
          categories: categories,
          frequencies: frequencies,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onAddExpenseSubmitted(
    AddExpenseSubmitted event,
    Emitter<AddExpenseState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _expensesRepository.add(
          token: event.token,
          object: Expense(
            amount: state.amount.value,
            date: state.date.value,
            category: state.category.value,
            frequency: state.frequency.value,
            isEnding: state.isEnding,
            endDate: state.endDate.value,
            isFixed: state.isFixed,
            isPlanned: event.isPlanned,
          ),
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (e) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
