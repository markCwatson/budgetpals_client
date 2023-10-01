import 'package:budgetpals_client/data/repositories/expenses/models/frequency.dart';
import 'package:hive/hive.dart';

part 'frequency_box.g.dart';

@HiveType(typeId: 2)
class FrequencyBox extends HiveObject {
  @HiveField(0)
  late String name;

  Frequency toFrequency() {
    return Frequency(
      name,
    );
  }
}
