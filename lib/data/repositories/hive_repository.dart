import 'package:budgetpals_client/data/repositories/irepository.dart';
import 'package:hive/hive.dart';

class HiveRepository<T> implements IRepository<T> {
  HiveRepository(this._box);

  final Box<T> _box;

  @override
  Future<List<T?>> get({required String token}) async {
    if (this.boxIsClosed) {
      return Future<List<T>>.value(List.empty());
    }

    return Future<List<T>>.value(this._box.values.toList());
  }

  @override
  Future<T?> getById({required String token, required String id}) async {
    if (this.boxIsClosed) {
      return Future<T>.value();
    }

    return Future<T>.value(this._box.get(id));
  }

  @override
  Future<void> add({required T object, required String token}) async {
    if (this.boxIsClosed) {
      return;
    }

    await this._box.add(object);
  }

  @override
  Future<void> update({
    required String token,
    required String id,
    required T object,
  }) async {
    if (this.boxIsClosed) {
      return;
    }

    await this._box.put(object.hashCode, object);
  }

  @override
  Future<void> delete({required String token, required String id}) async {
    if (this.boxIsClosed) {
      return;
    }

    await this._box.delete(id);
  }

  bool get boxIsClosed => !this._box.isOpen;
}
