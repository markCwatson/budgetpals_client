import 'package:budgetpals_client/add_expense/bloc/add_expense_bloc.dart';
import 'package:budgetpals_client/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class AddExpenseForm extends StatelessWidget {
  const AddExpenseForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddExpenseBloc, AddExpenseState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Expense Added')),
            );
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: const Center(
          child: SingleChildScrollView(
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
                        _CategoryAndFrequency(),
                        _IsEndingAndEndDateInput(),
                        _IsFixedInput(),
                        _SubmitButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
          padding: const EdgeInsets.only(left: 64, right: 64, top: 16),
          child: TextField(
            key: const Key('addExpenseForm_amountInput_textField'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              // Forcing it to be a double:
              // I noticed in database, if no decimal, stored as Int32
              final amount =
                  double.parse(value.contains('.') ? value : '$value.0001');
              context
                  .read<AddExpenseBloc>()
                  .add(AddExpenseAmountChanged(amount: amount));
            },
            decoration: const InputDecoration(
              labelText: r'Enter amount ($)',
            ),
          ),
        );
      },
    );
  }
}

class _CategoryAndFrequency extends StatefulWidget {
  const _CategoryAndFrequency();

  @override
  State<_CategoryAndFrequency> createState() => _CategoryAndFrequencyState();
}

class _CategoryAndFrequencyState extends State<_CategoryAndFrequency> {
  final List<String> _categories = ['None Selected'];
  final List<String> _frequencies = ['None Selected'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<AddExpenseBloc, AddExpenseState>(
              builder: (context, state) {
                if (state is CategoriesAndFrequenciesFetchedState &&
                    _categories.length == 1 &&
                    _frequencies.length == 1) {
                  state.categories
                      .map(
                        (e) => _categories.add(
                          e?.name ?? '',
                        ),
                      )
                      .toList();

                  state.frequencies
                      .map(
                        (e) => _frequencies.add(
                          e?.name ?? '',
                        ),
                      )
                      .toList();
                }

                if (_categories.isNotEmpty && _frequencies.isNotEmpty) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text('Category: '),
                            DropdownButton<String>(
                              items: _categories
                                  .map(
                                    (category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    ),
                                  )
                                  .toList(),
                              value: state.category.value,
                              onChanged: (value) =>
                                  context.read<AddExpenseBloc>().add(
                                        AddExpenseCategoryChanged(
                                          category: value ?? '',
                                        ),
                                      ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text('Frequency: '),
                            DropdownButton<String>(
                              items: _frequencies
                                  .map(
                                    (frequency) => DropdownMenuItem<String>(
                                      value: frequency,
                                      child: Text(frequency),
                                    ),
                                  )
                                  .toList(),
                              value: state.frequency.value,
                              onChanged: (value) =>
                                  context.read<AddExpenseBloc>().add(
                                        AddExpenseFrequencyChanged(
                                          frequency: value ?? '',
                                        ),
                                      ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const Text('Fetching categories...');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _IsEndingAndEndDateInput extends StatefulWidget {
  const _IsEndingAndEndDateInput();

  @override
  _IsEndingAndEndDateInputState createState() =>
      _IsEndingAndEndDateInputState();
}

class _IsEndingAndEndDateInputState extends State<_IsEndingAndEndDateInput> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Is Ending: '),
                  DropdownButton<bool>(
                    items: const [
                      DropdownMenuItem(
                        value: true,
                        child: Text('Yes'),
                      ),
                      DropdownMenuItem(
                        value: false,
                        child: Text('No'),
                      ),
                    ],
                    value: state.isEnding,
                    onChanged: (value) => context
                        .read<AddExpenseBloc>()
                        .add(AddExpenseIsEndingChanged(isEnding: value!)),
                  ),
                ],
              ),
              if (state
                  .isEnding) // Conditional rendering based on 'Is Ending' value
                Padding(
                  padding: const EdgeInsets.only(left: 32, right: 64),
                  child: GestureDetector(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                          final formattedDate = selectedDate!.toIso8601String();
                          context.read<AddExpenseBloc>().add(
                              AddExpenseEndDateChanged(endDate: formattedDate));
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        key: const Key('addExpenseForm_endDateInput_textField'),
                        controller: TextEditingController(
                          text: selectedDate != null
                              ? '${selectedDate!.toLocal()}'.split(' ')[0]
                              : '',
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Select an end date',
                          icon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _IsFixedInput extends StatelessWidget {
  const _IsFixedInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Is this amount fixed? '),
                  DropdownButton<bool>(
                    items: const [
                      DropdownMenuItem(
                        value: true,
                        child: Text('Yes'),
                      ),
                      DropdownMenuItem(
                        value: false,
                        child: Text('No'),
                      ),
                    ],
                    value: state.isFixed,
                    onChanged: (value) => context
                        .read<AddExpenseBloc>()
                        .add(AddExpenseIsFixedChanged(isFixed: value!)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(4),
          child: ElevatedButton(
            key: const Key('accountCreateForm_continue_raisedButton'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.secondary,
              backgroundColor: Colors.white,
            ),
            onPressed: state.isValid
                ? () {
                    context.read<AddExpenseBloc>().add(
                          AddExpenseSubmitted(
                            token: context.read<AuthBloc>().state.token,
                          ),
                        );
                  }
                : null,
            child: const Text('Submit'),
          ),
        );
      },
    );
  }
}
