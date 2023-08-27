import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category(this.name);

  final String name;

  @override
  List<Object> get props => [name];

  static const empty = Category('');
}
