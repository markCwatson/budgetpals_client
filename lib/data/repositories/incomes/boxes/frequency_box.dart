import 'package:budgetpals_client/data/repositories/incomes/models/frequency.dart';
import 'package:hive/hive.dart';

part 'frequency_box.g.dart';

@HiveType(typeId: 12)
class FrequencyBox extends HiveObject {
  @HiveField(0)
  late String name;

  Frequency toFrequency() {
    return Frequency(
      name,
    );
  }
}
