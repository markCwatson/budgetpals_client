import 'package:equatable/equatable.dart';

class Frequency extends Equatable {
  const Frequency(this.name);

  final String name;

  @override
  List<Object> get props => [name];

  static const empty = Frequency('');
}
