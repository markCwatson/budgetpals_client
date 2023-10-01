import 'package:budgetpals_client/data/repositories/expenses/models/category.dart';
import 'package:hive/hive.dart';

part 'category_box.g.dart';

@HiveType(typeId: 1)
class CategoryBox extends HiveObject {
  @HiveField(0)
  late String name;

  Category toCategory() {
    return Category(
      name,
    );
  }
}
