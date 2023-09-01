import 'package:bloc/bloc.dart';
import 'package:budgetpals_client/add_income/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:incomes_repository/incomes_repository.dart';

part 'add_income_event.dart';
part 'add_income_state.dart';

class AddIncomeBloc extends Bloc<AddIncomeEvent, AddIncomeState> {
  AddIncomeBloc({
    required IncomesRepository incomesRepository,
  })  : _incomesRepository = incomesRepository,
        super(const AddIncomeState()) {
    on<FetchCategoriesAndFrequenciesEvent>(
      _onFetchCategoriesAndFrequenciesEvent,
    );
    on<AddIncomeAmountChanged>(_onAmountChanged);
    on<AddIncomeDateChanged>(_onDateChanged);
    on<AddIncomeCategoryChanged>(_onCategoryChanged);
    on<AddIncomeFrequencyChanged>(_onFrequencyChanged);
    on<AddIncomeIsFixedChanged>(_onIsFixedChanged);
    on<AddIncomeIsEndingChanged>(_onIsEndingChanged);
    on<AddIncomeEndDateChanged>(_onEndDateChanged);
    on<AddIncomeSubmitted>(_onAddIncomeSubmitted);
  }

  final IncomesRepository _incomesRepository;

  void _onAmountChanged(
    AddIncomeAmountChanged event,
    Emitter<AddIncomeState> emit,
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
    AddIncomeDateChanged event,
    Emitter<AddIncomeState> emit,
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
    AddIncomeCategoryChanged event,
    Emitter<AddIncomeState> emit,
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
    AddIncomeFrequencyChanged event,
    Emitter<AddIncomeState> emit,
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
    AddIncomeEndDateChanged event,
    Emitter<AddIncomeState> emit,
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
    AddIncomeIsFixedChanged event,
    Emitter<AddIncomeState> emit,
  ) {
    emit(
      state.copyWith(
        isFixed: event.isFixed,
      ),
    );
  }

  void _onIsEndingChanged(
    AddIncomeIsEndingChanged event,
    Emitter<AddIncomeState> emit,
  ) {
    emit(
      state.copyWith(
        isEnding: event.isEnding,
      ),
    );
  }

  Future<void> _onFetchCategoriesAndFrequenciesEvent(
    FetchCategoriesAndFrequenciesEvent event,
    Emitter<AddIncomeState> emit,
  ) async {
    try {
      final categories =
          await _incomesRepository.getIncomeCategories(event.token);
      final frequencies =
          await _incomesRepository.getIncomeFrequencies(event.token);

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

  Future<void> _onAddIncomeSubmitted(
    AddIncomeSubmitted event,
    Emitter<AddIncomeState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _incomesRepository.addIncome(
          token: event.token,
          amount: state.amount.value,
          date: state.date.value,
          category: state.category.value,
          frequency: state.frequency.value,
          isEnding: state.isEnding,
          endDate: state.endDate.value,
          isFixed: state.isFixed,
          isPlanned: event.isPlanned,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (e) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
