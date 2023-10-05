import 'dart:async';

import 'package:budgetpals_client/data/providers/budgets/budgets_provider.dart';
import 'package:budgetpals_client/data/repositories/budgets/boxes/budget_box.dart';
import 'package:budgetpals_client/data/repositories/budgets/boxes/configuration_box.dart';
import 'package:budgetpals_client/data/repositories/budgets/boxes/frequency_box.dart';
import 'package:budgetpals_client/data/repositories/budgets/models/budget.dart';
import 'package:budgetpals_client/data/repositories/budgets/models/configuration.dart';
import 'package:budgetpals_client/data/repositories/budgets/models/frequency.dart';
import 'package:budgetpals_client/data/repositories/common_models/expense.dart';
import 'package:budgetpals_client/data/repositories/common_models/income.dart';
import 'package:budgetpals_client/data/repositories/hive_repository.dart';
import 'package:budgetpals_client/data/repositories/irepository.dart';
import 'package:hive/hive.dart';

class BudgetsRepository implements IRepository<Budget> {
  BudgetsRepository({
    required this.dataProvider,
  }) {
    _initializeBoxes();
  }

  final BudgetsDataProvider dataProvider;

  late HiveRepository<BudgetBox> _budgetCache;
  late HiveRepository<FrequencyBox> _frequencyCache;

  static const String _budgetBoxName = 'budget';
  static const String _frequencyBoxName = 'budgetFreq';
  static const String _configBoxName = 'config';

  void _initializeBoxes() {
    _budgetCache = HiveRepository<BudgetBox>(Hive.box(_budgetBoxName));
    _frequencyCache = HiveRepository<FrequencyBox>(Hive.box(_frequencyBoxName));

    _budgetCache.clear();
    _frequencyCache.clear();
  }

  @override
  Future<List<Budget?>> get({required String token}) async {
    final cachedBudgets = await _budgetCache.get();

    if (cachedBudgets.isNotEmpty) {
      final items = <Budget>[];

      for (final cachedBudget in cachedBudgets) {
        items.add(cachedBudget!.toBudget());
      }

      return items;
    }

    try {
      final data = await dataProvider.getBudget(token);
      if (data.isEmpty) return [];

      final userId = data['userId'] as String;

      final configuration = Configuration.fromJson(
        data['configuration'] as Map<String, dynamic>,
      );

      final unplannedExpenses = (data['unplannedExpenses'] as List).map((e) {
        return Expense.fromJson(e as Map<String, dynamic>);
      }).toList();

      final plannedExpenses = (data['plannedExpenses'] as List).map((e) {
        e['endDate'] ??= '';
        return Expense.fromJson(e as Map<String, dynamic>);
      }).toList();

      final unplannedIncomes = (data['unplannedIncomes'] as List).map((e) {
        return Income.fromJson(e as Map<String, dynamic>);
      }).toList();

      final plannedIncomes = (data['plannedIncomes'] as List).map((e) {
        e['endDate'] ??= '';
        return Income.fromJson(e as Map<String, dynamic>);
      }).toList();

      final budget = Budget(
        userId,
        configuration,
        plannedExpenses,
        plannedIncomes,
        unplannedExpenses,
        unplannedIncomes,
      );

      await _budgetCache.add(object: budget.toBudgetBox());

      return [budget];
    } catch (e) {
      throw Exception('Error fetching budget: $e');
    }
  }

  @override
  Future<Budget?> getById({required String token, required String id}) async {
    final cachedBudgets = await _budgetCache.get();

    if (cachedBudgets.isNotEmpty) {
      final items = <Budget>[];

      for (final cachedBudget in cachedBudgets) {
        items.add(cachedBudget!.toBudget());
      }

      return items.firstWhere((e) => e.userId == id);
    }

    try {
      final data = await dataProvider.getBudgetById(token, id);

      final userId = data['userId'] as String;

      final configuration = Configuration.fromJson(
        data['configuration'] as Map<String, dynamic>,
      );

      final unplannedExpenses = (data['unplannedExpenses'] as List).map((e) {
        return Expense.fromJson(e as Map<String, dynamic>);
      }).toList();

      final plannedExpenses = (data['plannedExpenses'] as List).map((e) {
        e['endDate'] ??= '';
        return Expense.fromJson(e as Map<String, dynamic>);
      }).toList();

      final unplannedIncomes = (data['unplannedIncomes'] as List).map((e) {
        return Income.fromJson(e as Map<String, dynamic>);
      }).toList();

      final plannedIncomes = (data['plannedIncomes'] as List).map((e) {
        e['endDate'] ??= '';
        return Income.fromJson(e as Map<String, dynamic>);
      }).toList();

      return Budget(
        userId,
        configuration,
        plannedExpenses,
        plannedIncomes,
        unplannedExpenses,
        unplannedIncomes,
      );
    } catch (e) {
      throw Exception('Error fetching budget');
    }
  }

  @override
  Future<void> add({
    required String token,
    required Budget object,
  }) async {
    try {
      final isSuccess = await dataProvider.addBudget(
        token: token,
        start: object.configuration.startDate,
        period: object.configuration.period,
        accountBalance: object.configuration.startAccountBalance,
      );

      if (isSuccess) await _budgetCache.clear();
    } catch (e) {
      throw Exception('Error adding budget');
    }
  }

  @override
  Future<void> update({
    required String token,
    required String id,
    required Budget object,
  }) async {
    try {
      final isSuccess = await dataProvider.updateBudget(
        token: token,
        id: id,
        budget: object,
      );

      if (isSuccess) await _budgetCache.clear();
    } catch (e) {
      throw Exception('Error updating budget');
    }
  }

  @override
  Future<void> delete({required String token, required String id}) async {
    try {
      final isSuccess = await dataProvider.deleteBudget(token: token, id: id);

      if (isSuccess) await _budgetCache.clear();
    } catch (e) {
      throw Exception('Error deleting budget');
    }
  }

  // not required for budgets repository
  @override
  Future<List<dynamic>> getCategories(String token) async {
    return [];
  }

  @override
  Future<List<Frequency?>> getFrequencies(String token) async {
    final cachedFrequencies = await _frequencyCache.get();

    if (cachedFrequencies.isNotEmpty) {
      final items = <Frequency>[];

      for (final cachedFrequency in cachedFrequencies) {
        items.add(cachedFrequency!.toFrequency());
      }

      return items;
    }

    try {
      final data = await dataProvider.getFrequencies(token);

      // ignore: unnecessary_lambdas
      final frequencies = data.map((str) => Frequency(str)).toList();

      for (final frequency in frequencies) {
        await _frequencyCache.add(object: frequency.toFrequencyBox());
      }

      return frequencies;
    } catch (e) {
      throw Exception('Error fetching frequencies');
    }
  }

  Future<void> clearCache() async {
    await _budgetCache.clear();
  }

  static Future<void> initializeBoxes() async {
    await IRepository.initBox<FrequencyBox>(
      _frequencyBoxName,
      FrequencyBoxAdapter(),
    );
    await IRepository.initBox<ConfigurationBox>(
      _configBoxName,
      ConfigurationBoxAdapter(),
    );
    await IRepository.initBox<BudgetBox>(
      _budgetBoxName,
      BudgetBoxAdapter(),
    );
  }
}
