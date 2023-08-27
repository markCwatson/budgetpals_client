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
      ];
}

final class CategoriesAndFrequenciesFetchedState extends AddExpenseState {
  const CategoriesAndFrequenciesFetchedState({
    required this.categories,
    required this.frequencies,
  });

  final List<Category?> categories;
  final List<Frequency?> frequencies;

  @override
  List<Object> get props => [categories, frequencies];
}
