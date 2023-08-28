import 'package:budgetpals_client/add_income/bloc/add_income_bloc.dart';
import 'package:budgetpals_client/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class AddIncomeForm extends StatelessWidget {
  const AddIncomeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddIncomeBloc, AddIncomeState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Income Added')),
            );
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });
        }
      },
      child: const Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                margin: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _AmountAndDateInput(),
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
    );
  }
}

class _AmountAndDateInput extends StatefulWidget {
  const _AmountAndDateInput();

  @override
  State<_AmountAndDateInput> createState() => _AmountAndDateInputState();
}

class _AmountAndDateInputState extends State<_AmountAndDateInput> {
  DateTime? selectedDate;

  void _datePicker() {
    final now = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: now,
    ).then(
      (value) => {
        if (value != null && value != selectedDate)
          {
            setState(() {
              selectedDate = value;
              final formattedDate = selectedDate!.toIso8601String();
              context.read<AddIncomeBloc>().add(
                    AddIncomeDateChanged(
                      date: formattedDate,
                    ),
                  );
            }),
          },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddIncomeBloc, AddIncomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('addIncomeForm_amountAndDateInput_textField'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    // Forcing it to be a double:
                    // I noticed in database, if no decimal, stored as Int32
                    final amount = double.parse(
                      value.contains('.') ? value : '$value.0001',
                    );
                    context
                        .read<AddIncomeBloc>()
                        .add(AddIncomeAmountChanged(amount: amount));
                  },
                  decoration: const InputDecoration(
                    labelText: 'Income Amount',
                    prefixText: r'$ ',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.toLocal()}'.split(' ')[0]
                          : 'Select a date',
                    ),
                    IconButton(
                      onPressed: _datePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
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
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
      // \todo: consder changing to ListView.builder
      child: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<AddIncomeBloc, AddIncomeState>(
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
                          children: [
                            const Text('Category: '),
                            const SizedBox(width: 16),
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
                                  context.read<AddIncomeBloc>().add(
                                        AddIncomeCategoryChanged(
                                          category: value ?? '',
                                        ),
                                      ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Frequency: '),
                            const SizedBox(width: 16),
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
                                  context.read<AddIncomeBloc>().add(
                                        AddIncomeFrequencyChanged(
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

  void _datePicker() {
    final now = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1, now.month, now.day),
    ).then(
      (value) => {
        if (value != null && value != selectedDate)
          {
            setState(() {
              selectedDate = value;
              final formattedDate = selectedDate!.toIso8601String();
              context.read<AddIncomeBloc>().add(
                    AddIncomeDateChanged(
                      date: formattedDate,
                    ),
                  );
            }),
          },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddIncomeBloc, AddIncomeState>(
      builder: (context, state) {
        if (state.frequency.value != 'Once') {
          return Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Text('Does it End? '),
                      const SizedBox(width: 16),
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
                            .read<AddIncomeBloc>()
                            .add(AddIncomeIsEndingChanged(isEnding: value!)),
                      ),
                    ],
                  ),
                ),
                if (state.isEnding)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          selectedDate != null
                              ? '${selectedDate!.toLocal()}'.split(' ')[0]
                              : 'Select a date',
                        ),
                        IconButton(
                          onPressed: _datePicker,
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _IsFixedInput extends StatelessWidget {
  const _IsFixedInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddIncomeBloc, AddIncomeState>(
      builder: (context, state) {
        if (state.frequency.value != 'Once') {
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Is this amount fixed? '),
                    const SizedBox(width: 16),
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
                          .read<AddIncomeBloc>()
                          .add(AddIncomeIsFixedChanged(isFixed: value!)),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddIncomeBloc, AddIncomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                key: const Key('accountCreateForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  backgroundColor: Colors.white,
                ),
                onPressed: state.isValid
                    ? () {
                        context.read<AddIncomeBloc>().add(
                              AddIncomeSubmitted(
                                token: context.read<AuthBloc>().state.token,
                              ),
                            );
                      }
                    : null,
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}
