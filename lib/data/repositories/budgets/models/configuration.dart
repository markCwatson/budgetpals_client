import 'package:budgetpals_client/data/repositories/budgets/boxes/configuration_box.dart';

class Configuration {
  const Configuration(
    this.startDate,
    this.period,
    this.startAccountBalance,
    this.runningBalance,
  );

  Configuration.fromJson(Map<String, dynamic> json)
      : startDate = json['startDate'] as String,
        period = json['period'] as String,
        startAccountBalance = json['startAccountBalance'] as double,
        runningBalance = json['runningBalance'] as double;

  final String startDate;
  final String period;
  final double startAccountBalance;
  final double runningBalance;

  static const empty = Configuration('', '', 0, 0);

  ConfigurationBox toConfigurationBox() {
    final configBox = ConfigurationBox()
      ..startDate = startDate
      ..period = period
      ..startAccountBalance = startAccountBalance
      ..runningBalance = runningBalance;
    return configBox;
  }
}
