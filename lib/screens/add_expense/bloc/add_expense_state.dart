part of 'add_expense_bloc.dart';

final class AddExpenseState extends Equatable {
  const AddExpenseState({
    this.status = FormzSubmissionStatus.initial,
    this.amount = const Amount.pure(),
    this.date = const Date.pure(),
    this.category = const CategoryForm.pure(),
    this.frequency = const FrequencyForm.pure(),
    this.isEnding = false,
    this.endDate = const EndDate.pure(),
    this.isFixed = false,
    this.isValid = false,
    this.isPlanned = false,
  });

  final FormzSubmissionStatus status;
  final Amount amount;
  final Date date;
  final CategoryForm category;
  final FrequencyForm frequency;
  final bool isEnding;
  final EndDate endDate;
  final bool isFixed;
  final bool isValid;
  final bool isPlanned;

  AddExpenseState copyWith({
    FormzSubmissionStatus? status,
    Amount? amount,
    Date? date,
    CategoryForm? category,
    FrequencyForm? frequency,
    bool? isEnding,
    EndDate? endDate,
    bool? isFixed,
    bool? isValid,
    bool? isPlanned,
  }) {
    return AddExpenseState(
      status: status ?? this.status,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      isEnding: isEnding ?? this.isEnding,
      endDate: endDate ?? this.endDate,
      isFixed: isFixed ?? this.isFixed,
      isValid: isValid ?? this.isValid,
      isPlanned: isPlanned ?? this.isPlanned,
    );
  }

  @override
  List<Object> get props => [
        status,
        amount,
        date,
        category,
        frequency,
        isEnding,
        isFixed,
        endDate,
        isPlanned,
      ];
}

final class CategoriesAndFrequenciesFetchedState extends AddExpenseState {
  const CategoriesAndFrequenciesFetchedState({
    required this.categories,
    required this.frequencies,
    FormzSubmissionStatus? status,
    Amount? amount,
    Date? date,
    bool? isEnding,
    EndDate? endDate,
    bool? isFixed,
    bool? isValid,
    bool? isPlanned,
  }) : super(
          status: status ?? FormzSubmissionStatus.initial,
          amount: amount ?? const Amount.pure(),
          date: date ?? const Date.pure(),
          isEnding: isEnding ?? false,
          endDate: endDate ?? const EndDate.pure(),
          isFixed: isFixed ?? false,
          isValid: isValid ?? false,
          isPlanned: isPlanned ?? false,
        );

  final List<Category?> categories;
  final List<Frequency?> frequencies;

  @override
  List<Object> get props => [categories, frequencies, ...super.props];
}

final class PlannedExpensesFetchedState extends AddExpenseState {
  const PlannedExpensesFetchedState({
    required this.plannedExpenses,
    FormzSubmissionStatus? status,
    Amount? amount,
    Date? date,
    CategoryForm? category,
    FrequencyForm? frequency,
    bool? isEnding,
    EndDate? endDate,
    bool? isFixed,
    bool? isValid,
    bool? isPlanned,
  }) : super(
          status: status ?? FormzSubmissionStatus.initial,
          amount: amount ?? const Amount.pure(),
          date: date ?? const Date.pure(),
          category: category ?? const CategoryForm.pure(),
          frequency: frequency ?? const FrequencyForm.pure(),
          isEnding: isEnding ?? false,
          endDate: endDate ?? const EndDate.pure(),
          isFixed: isFixed ?? false,
          isValid: isValid ?? false,
          isPlanned: isPlanned ?? true,
        );

  final List<Expense?> plannedExpenses;

  @override
  List<Object> get props => [plannedExpenses, ...super.props];
}
