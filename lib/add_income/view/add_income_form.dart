import 'package:budgetpals_client/add_income/bloc/add_income_bloc.dart';
import 'package:budgetpals_client/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class AddIncomeForm extends StatefulWidget {
  const AddIncomeForm({
    required this.title,
    required this.isPlanned,
    super.key,
  });

  final String title;
  final bool isPlanned;

  @override
  State<AddIncomeForm> createState() => _AddIncomeFormState();
}

class _AddIncomeFormState extends State<AddIncomeForm> {
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
      child: BlocBuilder<AddIncomeBloc, AddIncomeState>(
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _Title(title: widget.title),
                          if (!widget.isPlanned) const _SetIsPlannedIncome(),
                          if (!state.isPlanned)
                            const Column(
                              children: [
                                _AmountAndDateInput(),
                                _CategoryAndFrequency(),
                                _IsEndingAndEndDateInput(),
                                _IsFixedInput(),
                              ],
                            ),
                          if (state.isPlanned)
                            const Column(
                              children: [
                                _SelectPlannedIncome(),
                              ],
                            ),
                          // \todo: consider changing name to isPlannedBeingAdded
                          _SubmitButton(isPlanned: widget.isPlanned),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.black38,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

class _SetIsPlannedIncome extends StatefulWidget {
  const _SetIsPlannedIncome();

  @override
  State<_SetIsPlannedIncome> createState() => _SetIsPlannedIncomeState();
}

class _SetIsPlannedIncomeState extends State<_SetIsPlannedIncome> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddIncomeBloc, AddIncomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
          child: Row(
            children: [
              const Text('Is this a planned income? '),
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
                value: state.isPlanned,
                dropdownColor:
                    Theme.of(context).colorScheme.onSecondaryContainer,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                onChanged: (value) {
                  context.read<AddIncomeBloc>().add(
                        AddIncomeTypeSelected(
                          isPlanned: value!,
                        ),
                      );
                  if (value) {
                    context.read<AddIncomeBloc>().add(
                          FetchPlannedIncomesEvent(
                            token: context.read<AuthBloc>().state.token,
                          ),
                        );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SelectPlannedIncome extends StatefulWidget {
  const _SelectPlannedIncome();

  @override
  State<_SelectPlannedIncome> createState() => _SelectPlannedIncomeState();
}

class _SelectPlannedIncomeState extends State<_SelectPlannedIncome> {
  String? _selectedIncomeId = 'default';

  final List<Map<String, String>> _plannedIncomes = [
    {'id': 'default', 'title': 'None'},
  ];

  String showAmount(double? amount) => amount?.toStringAsFixed(2) ?? '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddIncomeBloc, AddIncomeState>(
      builder: (context, state) {
        if (state is PlannedIncomesFetchedState &&
            _plannedIncomes.length == 1) {
          state.plannedIncomes
              .map(
                (e) => _plannedIncomes.add(
                  {
                    'id': e?.id ?? '',
                    'title': '${e?.category}: \$${showAmount(e?.amount)}',
                  },
                ),
              )
              .toList();
        }

        return Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
          child: Row(
            children: [
              Row(
                children: [
                  const Text('Selection: '),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                      items: _plannedIncomes
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e['id'],
                              child: Text('${e['title']}'),
                            ),
                          )
                          .toList(),
                      value: _selectedIncomeId,
                      dropdownColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedIncomeId = value;
                        });

                        context.read<AddIncomeBloc>().add(
                              PlannedIncomeSelected(
                                token: context.read<AuthBloc>().state.token,
                                plannedIncomeId: value ?? '',
                              ),
                            );
                      }),
                ],
              ),
            ],
          ),
        );
      },
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
                    labelText: 'Amount',
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
                          : 'Select Date ',
                    ),
                    IconButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
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
                              dropdownColor: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              menuMaxHeight: 400,
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
                              dropdownColor: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
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
                        dropdownColor:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
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
                              : 'Select Date ',
                        ),
                        IconButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).colorScheme.primaryContainer,
                            ),
                          ),
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
                      dropdownColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
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
  const _SubmitButton({
    required this.isPlanned,
  });

  final bool isPlanned;

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
                                isPlanned: isPlanned,
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
