import 'package:budgetpals_client/data/repositories/budgets/models/configuration.dart';
import 'package:hive/hive.dart';

part 'configuration_box.g.dart';

@HiveType(typeId: 21)
class ConfigurationBox extends HiveObject {
  @HiveField(0)
  late String startDate;

  @HiveField(1)
  late String period;

  @HiveField(2)
  late double startAccountBalance;

  @HiveField(3)
  late double runningBalance;

  Configuration toConfiguration() {
    return Configuration(
      startDate,
      period,
      startAccountBalance,
      runningBalance,
    );
  }
}
