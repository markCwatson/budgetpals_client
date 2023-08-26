import 'package:budgetpals_client/add_expense/bloc/add_expense_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExpenseForm extends StatelessWidget {
  const AddExpenseForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddExpenseBloc, AddExpenseState>(
      listener: (context, state) {
        print(state);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                margin: EdgeInsets.all(32),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _AmountInput(),
                      _Categories(),
                      // _FrequencyInput(),
                      // _IsEndingInput(),
                      // _EndDateInput(),
                      // _IsFixedInput(),
                      // _SubmitButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            key: const Key('addExpenseForm_amountInput_textField'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              // Do something when the amount is changed
            },
            decoration: const InputDecoration(
              labelText: 'Enter amount',
            ),
          ),
        );
      },
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      builder: (context, state) {
        if (state is CategoriesFetchedState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Category: '),
              DropdownButton<String>(
                items: state.categories
                    .map(
                      (category) => DropdownMenuItem<String>(
                        value: category?.name ?? '',
                        child: Text(category?.name ?? ''),
                      ),
                    )
                    .toList(),
                value: state.categories[0]?.name ?? '',
                onChanged: (value) {
                  // Do something when a category is selected
                },
              ),
            ],
          );
        }
        return const Text('Fetching categories...');
      },
    );
  }
}
