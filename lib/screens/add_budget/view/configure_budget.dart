import 'package:budgetpals_client/screens/add_budget/bloc/add_budget_bloc.dart';
import 'package:budgetpals_client/screens/auth/bloc/auth_bloc.dart';
import 'package:budgetpals_client/screens/budget/view/budget_page.dart';
import 'package:budgetpals_client/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfigureBudget extends StatefulWidget {
  const ConfigureBudget({super.key});

  @override
  State<ConfigureBudget> createState() => _ConfigureBudgetState();
}

class _ConfigureBudgetState extends State<ConfigureBudget> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AddBudgetBloc, AddBudgetState>(
      listener: (context, state) {
        if (state is BudgetExists) {
          Navigator.of(context).push(BudgetPage.route());
          return;
        }

        if (state is AddBudgetSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  'Success',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          Navigator.of(context).push(BudgetPage.route());
          return;
        }

        if (state is AddBudgetFailed) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: const Text(
                  'Failed to add budget',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          return;
        }
      },
      child: const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _Title(),
                  _AmountInput(),
                  _DateInput(),
                  _Period(),
                  _SubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16, top: 16, right: 16),
      child: Column(
        children: [
          Text(
            'Hello!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Let's create your first budget...",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.white60,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

class _AmountInput extends StatefulWidget {
  const _AmountInput();

  @override
  State<_AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<_AmountInput> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBudgetBloc, AddBudgetState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
          child: TextField(
            key: const Key('configBudget_amountAndDateInput_textField'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              // Forcing it to be a double:
              // I noticed in database, if no decimal, stored as Int32
              final amount = double.parse(
                value.contains('.') ? value : '$value.00011',
              );
              context.read<AddBudgetBloc>().add(
                    AddStartAccountBalanceChanged(
                      startAccountBalance: amount,
                    ),
                  );
            },
            decoration: const InputDecoration(
              labelText: 'Account Balance',
              prefixText: r'$ ',
            ),
          ),
        );
      },
    );
  }
}

class _DateInput extends StatefulWidget {
  const _DateInput();

  @override
  State<_DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<_DateInput> {
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
              context.read<AddBudgetBloc>().add(
                    AddStartDateChanged(
                      startDate: formattedDate,
                    ),
                  );
            }),
          },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBudgetBloc, AddBudgetState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.toLocal()}'.split(' ')[0]
                          : 'Select The Start Date ',
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

class _Period extends StatefulWidget {
  const _Period();

  @override
  State<_Period> createState() => _PeriodState();
}

class _PeriodState extends State<_Period> {
  final List<String> _periods = ['None Selected'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<AddBudgetBloc, AddBudgetState>(
              builder: (context, state) {
                if (state is GetBudgetPeriodsSuccess && _periods.length == 1) {
                  state.periods
                      .map(
                        (e) => _periods.add(e),
                      )
                      .toList();
                }

                if (_periods.isNotEmpty) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text('Period: '),
                            const SizedBox(width: 16),
                            DropdownButton<String>(
                              items: _periods
                                  .map(
                                    (category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    ),
                                  )
                                  .toList(),
                              value: state.period.value,
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
                                  context.read<AddBudgetBloc>().add(
                                        AddPeriodChanged(
                                          period: value ?? '',
                                        ),
                                      ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const Text('Fetching periods...');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBudgetBloc, AddBudgetState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(LoginPage.route());
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                key: const Key('addBudget_raisedButton'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  backgroundColor: Colors.white,
                  disabledBackgroundColor:
                      Theme.of(context).colorScheme.secondary,
                ),
                onPressed: state.isValid
                    ? () {
                        context.read<AddBudgetBloc>().add(
                              AddBudgetConfigEvent(
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
