import 'dart:async';

import 'package:budgetpals_client/data/providers/expenses/expenses_provider.dart';
import 'package:budgetpals_client/data/repositories/common_models/expense.dart';
import 'package:budgetpals_client/data/repositories/expenses/boxes/category_box.dart';
import 'package:budgetpals_client/data/repositories/expenses/boxes/expense_box.dart';
import 'package:budgetpals_client/data/repositories/expenses/boxes/frequency_box.dart';
import 'package:budgetpals_client/data/repositories/expenses/models/category.dart';
import 'package:budgetpals_client/data/repositories/expenses/models/frequency.dart';
import 'package:budgetpals_client/data/repositories/hive_repository.dart';
import 'package:budgetpals_client/data/repositories/irepository.dart';
import 'package:hive/hive.dart';

/// This class implements the IRepository interface for Expense objects.
/// It provides methods for CRUD operations on expenses, as well as additional
/// methods for fetching expense categories and frequencies.
class ExpensesRepository implements IRepository<Expense> {
  /// Constructor that initializes the data provider and Hive boxes for caching.
  ExpensesRepository({
    required this.dataProvider,
  }) {
    _initializeBoxes();
  }

  /// Data provider for fetching data from the API.
  final ExpensesDataProvider dataProvider;

  // hive boxes for caching API data
  late HiveRepository<ExpenseBox> _expenseCache;
  late HiveRepository<CategoryBox> _categoryCache;
  late HiveRepository<FrequencyBox> _frequencyCache;

  /// box names
  static const String _expenseBoxName = 'expenses';
  static const String _categoryBoxName = 'expenseCategories';
  static const String _frequencyBoxName = 'expenseFreq';

  /// Initializes the Hive boxes for caching.
  void _initializeBoxes() {
    _expenseCache = HiveRepository<ExpenseBox>(Hive.box(_expenseBoxName));
    _categoryCache = HiveRepository<CategoryBox>(Hive.box(_categoryBoxName));
    _frequencyCache = HiveRepository<FrequencyBox>(Hive.box(_frequencyBoxName));

    _expenseCache.clear();
    _categoryCache.clear();
    _frequencyCache.clear();
  }

  /// Fetches a list of expenses either from the cache or the API.
  @override
  Future<List<Expense?>> get({required String token}) async {
    final cachedExpenses = await _expenseCache.get();

    if (cachedExpenses.isNotEmpty) {
      final items = <Expense>[];

      for (final cachedExpense in cachedExpenses) {
        items.add(cachedExpense!.toExpense());
      }

      return items;
    }

    try {
      final data = await dataProvider.getExpenses(token);

      final expenses = data.map(
        (e) {
          // endDate may not exist
          // \todo: come up with a different approach for this
          e['endDate'] ??= '';

          return Expense.fromJson(e);
        },
      ).toList();

      for (final expense in expenses) {
        await _expenseCache.add(object: expense.toExpenseBox());
      }

      return expenses;
    } catch (e) {
      print(e);
      throw Exception('Error fetching expenses');
    }
  }

  /// Fetches a single expense by its ID either from the cache or the API.
  @override
  Future<Expense?> getById({required String token, required String id}) async {
    final cachedExpenses = await _expenseCache.get();

    if (cachedExpenses.isNotEmpty) {
      final items = <Expense>[];

      for (final cachedExpense in cachedExpenses) {
        items.add(cachedExpense!.toExpense());
      }

      return items.firstWhere((e) => e.id == id);
    }

    try {
      final data = await dataProvider.getExpenseById(token, id);
      return Expense.fromJson(data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// Adds a new expense to the API and clears the cache.
  @override
  Future<void> add({
    required Expense object,
    required String token,
  }) async {
    try {
      final isSuccess = await dataProvider.addExpense(
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

      if (isSuccess) await _expenseCache.clear();
    } catch (e) {
      print(e);
    }
  }

  /// Updates an existing expense in the API and clears the cache.
  @override
  Future<void> update({
    required String token,
    required String id,
    required Expense object,
  }) async {
    try {
      final isSuccess = await dataProvider.updateExpense(
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

      if (isSuccess) await _expenseCache.clear();
    } catch (e) {
      print(e);
    }
  }

  /// Deletes an expense from the API and clears the cache.
  @override
  Future<void> delete({
    required String token,
    required String id,
  }) async {
    try {
      final isSuccess = await dataProvider.deleteExpense(
        token: token,
        id: id,
      );

      if (isSuccess) await _expenseCache.clear();
    } catch (e) {
      print(e);
    }
  }

  /// Fetches a list of expense categories either from the cache or the API.
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

  /// Fetches a list of expense frequencies either from the cache or the API.
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

  Future<void> clearCache() async {
    await _expenseCache.clear();
  }

  /// Static method to initialize Hive boxes before using them.
  static Future<void> initializeBoxes() async {
    await IRepository.initBox<ExpenseBox>(
      _expenseBoxName,
      ExpenseBoxAdapter(),
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
