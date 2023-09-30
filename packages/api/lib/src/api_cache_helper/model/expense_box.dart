import 'package:hive/hive.dart';

part 'expense_box.g.dart';

const int type = 0; // unique for every class

@HiveType(typeId: type)
class ApiResponseBox extends HiveObject {
  @HiveField(0)
  late String url;

  @HiveField(1)
  late String response;

  @HiveField(2)
  late int timestamp;

  // getter for type
  static int get getType => type;
}
