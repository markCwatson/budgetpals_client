/// An abstract repository interface for generic data operations.
///
/// This interface defines the basic CRUD operations that any repository
/// should support. It is generic, meaning it can be implemented for
/// any type [T].
///
/// The [token] parameter is required for all methods to handle authentication.
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
}
