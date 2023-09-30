abstract class IRepository<T> {
  Future<List<T?>> get({required String token});
  Future<T?> getById({required String token, required String id});
  Future<void> add({required String token, required T object});
  Future<void> update({
    required String token,
    required String id,
    required T object,
  });
  Future<void> delete({required String token, required String id});
}
