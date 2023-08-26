part of 'add_expense_bloc.dart';

sealed class AddExpenseState extends Equatable {
  const AddExpenseState();

  @override
  List<Object> get props => [];
}

final class AddExpenseInitial extends AddExpenseState {}
