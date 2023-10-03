import 'package:budgetpals_client/data/repositories/budgets/models/frequency.dart';
import 'package:hive/hive.dart';

part 'frequency_box.g.dart';

@HiveType(typeId: 22)
class FrequencyBox extends HiveObject {
  @HiveField(0)
  late String name;

  Frequency toFrequency() {
    return Frequency(
      name,
    );
  }
}
