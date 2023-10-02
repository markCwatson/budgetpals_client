import 'dart:async';

import 'package:budgetpals_client/data/providers/incomes/incomes_provider.dart';
import 'package:budgetpals_client/data/repositories/common_models/income.dart';
import 'package:budgetpals_client/data/repositories/hive_repository.dart';
import 'package:budgetpals_client/data/repositories/incomes/boxes/category_box.dart';
import 'package:budgetpals_client/data/repositories/incomes/boxes/frequency_box.dart';
import 'package:budgetpals_client/data/repositories/incomes/boxes/income_box.dart';
import 'package:budgetpals_client/data/repositories/incomes/models/category.dart';
import 'package:budgetpals_client/data/repositories/incomes/models/frequency.dart';
import 'package:budgetpals_client/data/repositories/irepository.dart';
import 'package:hive/hive.dart';

/// This class implements the IRepository interface for Income objects.
/// It provides methods for CRUD operations on incomes, as well as additional
/// methods for fetching income categories and frequencies.
class IncomesRepository implements IRepository<Income> {
  /// Constructor that initializes the data provider and Hive boxes for caching.
  IncomesRepository({
    required this.dataProvider,
  }) {
    _initializeBoxes();
  }

  /// Data provider for fetching data from the API.
  final IncomesDataProvider dataProvider;

  // hive boxes for caching API data
  late HiveRepository<IncomeBox> _incomeCache;
  late HiveRepository<CategoryBox> _categoryCache;
  late HiveRepository<FrequencyBox> _frequencyCache;

  /// box names
  static const String _incomeBoxName = 'incomes';
  static const String _categoryBoxName = 'incomeCategories';
  static const String _frequencyBoxName = 'incomeFreq';

  /// Initializes the Hive boxes for caching.
  void _initializeBoxes() {
    _incomeCache = HiveRepository<IncomeBox>(Hive.box(_incomeBoxName));
    _categoryCache = HiveRepository<CategoryBox>(Hive.box(_categoryBoxName));
    _frequencyCache = HiveRepository<FrequencyBox>(Hive.box(_frequencyBoxName));
  }

  /// Fetches a list of incomes either from the cache or the API.
  @override
  Future<List<Income?>> get({required String token}) async {
    final cachedIncomes = await _incomeCache.get();

    if (cachedIncomes.isNotEmpty) {
      final items = <Income>[];

      for (final cachedIncome in cachedIncomes) {
        items.add(cachedIncome!.toIncome());
      }

      return items;
    }

    try {
      final data = await dataProvider.getIncomes(token);

      final incomes = data.map(
        (e) {
          // endDate may not exist
          // \todo: come up with a different approach for this
          e['endDate'] ??= '';

          return Income.fromJson(e);
        },
      ).toList();

      for (final income in incomes) {
        await _incomeCache.add(object: income.toIncomeBox());
      }

      return incomes;
    } catch (e) {
      print(e);
      throw Exception('Error fetching incomes');
    }
  }

  /// Fetches a single income by its ID either from the cache or the API.
  @override
  Future<Income?> getById({required String token, required String id}) async {
    final cachedIncomes = await _incomeCache.get();

    if (cachedIncomes.isNotEmpty) {
      final items = <Income>[];

      for (final cachedIncome in cachedIncomes) {
        items.add(cachedIncome!.toIncome());
      }

      return items.firstWhere((e) => e.id == id);
    }

    try {
      final data = await dataProvider.getIncomeById(token, id);
      return Income.fromJson(data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// Adds a new income to the API and clears the cache.
  @override
  Future<void> add({
    required Income object,
    required String token,
  }) async {
    try {
      final isSuccess = await dataProvider.addIncome(
        token: token,
        amount: object.amount,
        date: object.date,
        category: object.category,
        frequency: object.frequency,
        isEnding: object.isEnding,
        endDate: object.endDate,
        isFixed: object.isFixed,
        isPlanned: object.isPlanned,
      );

      if (isSuccess) await _incomeCache.clear();
    } catch (e) {
      print(e);
    }
  }

  /// Updates an existing income in the API and clears the cache.
  @override
  Future<void> update({
    required String token,
    required String id,
    required Income object,
  }) async {
    try {
      final isSuccess = await dataProvider.updateIncome(
        token: token,
        id: id,
        amount: object.amount,
        date: object.date,
        category: object.category,
        frequency: object.frequency,
        isEnding: object.isEnding,
        endDate: object.endDate,
        isFixed: object.isFixed,
        isPlanned: object.isPlanned,
      );

      if (isSuccess) await _incomeCache.clear();
    } catch (e) {
      print(e);
    }
  }

  /// Deletes an income from the API and clears the cache.
  @override
  Future<void> delete({
    required String token,
    required String id,
  }) async {
    try {
      final isSuccess = await dataProvider.deleteIncome(
        token: token,
        id: id,
      );

      if (isSuccess) await _incomeCache.clear();
    } catch (e) {
      print(e);
    }
  }

  /// Fetches a list of income categories either from the cache or the API.
  @override
  Future<List<Category?>> getCategories(String token) async {
    final cachedCategories = await _categoryCache.get();

    if (cachedCategories.isNotEmpty) {
      final items = <Category>[];

      for (final cachedCategory in cachedCategories) {
        items.add(cachedCategory!.toCategory());
      }

      return items;
    }

    try {
      final data = await dataProvider.getCategories(token);

      // ignore: unnecessary_lambdas
      final categories = data.map((str) => Category(str)).toList();

      for (final category in categories) {
        await _categoryCache.add(object: category.toCategoryBox());
      }

      return categories;
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  /// Fetches a list of income frequencies either from the cache or the API.
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
      print(e);
      return List.empty();
    }
  }

  /// Static method to initialize Hive boxes before using them.
  static Future<void> initializeBoxes() async {
    await IRepository.initBox<IncomeBox>(
      _incomeBoxName,
      IncomeBoxAdapter(),
    );
    await IRepository.initBox<CategoryBox>(
      _categoryBoxName,
      CategoryBoxAdapter(),
    );
    await IRepository.initBox<FrequencyBox>(
      _frequencyBoxName,
      FrequencyBoxAdapter(),
    );
  }
}
