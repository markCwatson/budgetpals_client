import 'package:api/api.dart';
import 'package:budgetpals_client/add_income/bloc/add_income_bloc.dart';
import 'package:budgetpals_client/add_income/view/add_income_form.dart';
import 'package:budgetpals_client/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incomes_repository/incomes_repository.dart';

class AddIncomeModal extends StatelessWidget {
  AddIncomeModal({super.key});

  static const url = String.fromEnvironment('API_URL');

  final IncomesRepository _incomesRepository = IncomesRepository(
    dataProvider: IncomesDataProvider(baseUrl: url),
  );

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => AddIncomeModal());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: BlocProvider(
        create: (context) {
          final bloc = AddIncomeBloc(
            incomesRepository: _incomesRepository,
          )
            // Dispatch an events to fetching the categories/frequencies
            ..add(
              FetchCategoriesAndFrequenciesEvent(
                token: context.read<AuthBloc>().state.token,
              ),
            );
          return bloc;
        },
        child: const AddIncomeForm(),
      ),
    );
  }
}
