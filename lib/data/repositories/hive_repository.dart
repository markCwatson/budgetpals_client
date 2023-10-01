import 'package:hive/hive.dart';

/// A generic repository for Hive boxes.
/// Data is cached in a Hive box of type [T].
///
/// This class provides a high-level API to interact with Hive boxes,
/// abstracting away the lower-level operations.
class HiveRepository<T> {
  /// Constructor that initializes the Hive box.
  ///
  /// [_box] is the Hive box where the data will be stored.
  HiveRepository(this._box);

  /// The Hive box where data of type [T] is stored.
  final Box<T> _box;

  /// Fetches all the values stored in the Hive box.
  ///
  /// Returns a Future containing a list of all values in the box.
  /// If the box is closed, an empty list is returned.
  Future<List<T?>> get() async {
    if (this.boxIsClosed) {
      return Future<List<T>>.value(List.empty());
    }

    return Future<List<T>>.value(this._box.values.toList());
  }

  /// Adds a new object to the Hive box.
  ///
  /// [object] is the object of type [T] to be added to the box.
  /// Returns a Future containing the object that was added.
  /// If the box is closed, the original object is returned.
  Future<T> add({required T object}) async {
    if (this.boxIsClosed) {
      return Future<T>.value(object);
    }

    await this._box.add(object);

    return Future<T>.value(object);
  }

  /// Clears all the data in the Hive box.
  ///
  /// If the box is closed, this method does nothing.
  Future<void> clear() async {
    if (this.boxIsClosed) {
      return;
    }

    await this._box.clear();
  }

  /// Checks if the Hive box is closed.
  ///
  /// Returns true if the box is closed, otherwise false.
  bool get boxIsClosed => !this._box.isOpen;
}
