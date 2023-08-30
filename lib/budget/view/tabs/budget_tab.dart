import 'package:budgetpals_client/budget/bloc/budgets_bloc.dart';
import 'package:budgetpals_client/utilities/utilities.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetTab extends StatelessWidget {
  const BudgetTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetsBloc, BudgetsState>(
      builder: (context, state) {
        return const LoadingIndicator();
      },
    );
  }
}
