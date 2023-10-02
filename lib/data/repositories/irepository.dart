import 'package:hive_flutter/hive_flutter.dart';

/// An abstract repository interface for generic data operations.
///
/// This interface defines the basic CRUD operations that any repository
/// should support. It is generic, meaning it can be implemented for
/// any type [T].
abstract class IRepository<T> {
  /// Fetches a list of objects of type [T].
  ///
  /// [token] is the authentication token.
  ///
  /// Returns a [Future] containing a list of objects of type [T].
  /// The list can contain null values, hence the return type is `List<T?>`.
  Future<List<T?>> get({required String token});

  /// Fetches a single object of type [T] by its [id].
  ///
  /// [token] is the authentication token.
  /// [id] is the unique identifier for the object.
  ///
  /// Returns a [Future] containing the object of type [T] or null if not found.
  Future<T?> getById({required String token, required String id});

  /// Adds a new object of type [T].
  ///
  /// [token] is the authentication token.
  /// [object] is the object to be added.
  ///
  /// Returns a [Future] that completes when the object has been added.
  Future<void> add({required String token, required T object});

  /// Updates an existing object of type [T] by its [id].
  ///
  /// [token] is the authentication token.
  /// [id] is the unique identifier for the object.
  /// [object] is the updated object.
  ///
  /// Returns a [Future] that completes when the object has been updated.
  Future<void> update({
    required String token,
    required String id,
    required T object,
  });

  /// Deletes an object of type [T] by its [id].
  ///
  /// [token] is the authentication token.
  /// [id] is the unique identifier for the object.
  ///
  /// Returns a [Future] that completes when the object has been deleted.
  Future<void> delete({required String token, required String id});

  /// Fetches a list of categories.
  ///
  /// [token] is the authentication token.
  ///
  /// Returns a [Future] containing a list of categories.
  Future<List<dynamic>> getCategories(String token);

  /// Fetches a list of frequencies.
  ///
  /// [token] is the authentication token.
  ///
  /// Returns a [Future] containing a list of frequencies.
  Future<List<dynamic>> getFrequencies(String token);

  /// Initializes a box in Hive.
  ///
  /// [key] is the name of the box.
  /// [boxAdapter] is the adapter for the box.
  ///
  /// Returns a [Future] that completes when the box has been initialized.
  static Future<void> initBox<B>(
    String key,
    TypeAdapter<B> boxAdapter,
  ) async {
    Hive.registerAdapter<B>(boxAdapter);
    await Hive.openBox<B>(key);
  }
}
