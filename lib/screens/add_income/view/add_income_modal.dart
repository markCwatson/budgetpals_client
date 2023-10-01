import 'package:budgetpals_client/data/providers/incomes/incomes_provider.dart';
import 'package:budgetpals_client/data/repositories/incomes/incomes_repository.dart';
import 'package:budgetpals_client/screens/add_income/bloc/add_income_bloc.dart';
import 'package:budgetpals_client/screens/add_income/view/add_income_form.dart';
import 'package:budgetpals_client/screens/auth/bloc/auth_bloc.dart';
import 'package:budgetpals_client/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddIncomeModal extends StatelessWidget {
  AddIncomeModal({
    required this.title,
    required this.isPlanned,
    super.key,
  });

  final String title;
  final bool isPlanned;

  static final url = Url.getUrl();

  final IncomesRepository _incomesRepository = IncomesRepository(
    dataProvider: IncomesDataProvider(baseUrl: url),
  );

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => AddIncomeModal(
        title: 'Add an income',
        isPlanned: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
          child: AddIncomeForm(
            title: title,
            isPlanned: isPlanned,
          ),
        ),
      ),
    );
  }
}
