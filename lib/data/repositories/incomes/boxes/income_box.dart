import 'package:budgetpals_client/data/repositories/common_models/income.dart';
import 'package:hive/hive.dart';

part 'income_box.g.dart';

@HiveType(typeId: 10)
class IncomeBox extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String frequency;

  @HiveField(2)
  late bool isEnding;

  @HiveField(3)
  late String endDate;

  @HiveField(4)
  late bool isFixed;

  @HiveField(5)
  late String userId;

  @HiveField(6)
  late bool isPlanned;

  @HiveField(7)
  late double amount;

  @HiveField(8)
  late String date;

  @HiveField(9)
  late String category;

  Income toIncome() {
    return Income(
      id: id,
      amount: amount,
      date: date,
      category: category,
      frequency: frequency,
      isEnding: isEnding,
      endDate: endDate,
      isFixed: isFixed,
      userId: userId,
      isPlanned: isPlanned,
    );
  }
}
