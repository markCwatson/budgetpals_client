import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'add_expense_event.dart';
part 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  AddExpenseBloc({
    required ExpensesRepository expensesRepository,
    required UserRepository userRepository,
  })  : _expensesRepository = expensesRepository,
        _userRepository = userRepository,
        super(AddExpenseInitial()) {}

  final ExpensesRepository _expensesRepository;
  final UserRepository _userRepository;
}
