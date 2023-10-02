import 'package:budgetpals_client/data/repositories/incomes/boxes/category_box.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category(this.name);

  final String name;

  @override
  List<Object> get props => [name];

  static const empty = Category('');

  CategoryBox toCategoryBox() {
    return CategoryBox()..name = name;
  }
}
