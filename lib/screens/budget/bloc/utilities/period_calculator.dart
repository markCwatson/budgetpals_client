class BudgetPeriod {
  const BudgetPeriod(this.start, this.end);

  // Note: I had to allow these to be null because DateTime does not have a
  // const constructor. See dart-sdk issue https://github.com/dart-lang/sdk/issues/17014
  final DateTime? start;
  final DateTime? end;

  static const empty = BudgetPeriod(null, null);
}

class PeriodCalculator {
  const PeriodCalculator();

  BudgetPeriod calculateCurrentPeriod(
    DateTime createdAt,
    String periodType,
    DateTime today,
  ) {
    var startOfCurrentPeriod = createdAt;
    DateTime endOfCurrentPeriod;

    if (today.isBefore(createdAt)) {
      throw ArgumentError(
        "Today's date cannot be before the budget creation date.",
      );
    }

    final timeSinceCreation = today.difference(createdAt);
    var firstPeriodLength = Duration.zero;

    if (periodType == 'Weekly') {
      firstPeriodLength = const Duration(days: 7);
    } else if (periodType == 'Bi-weekly') {
      firstPeriodLength = const Duration(days: 14);
    } else if (periodType == 'Monthly') {
      firstPeriodLength =
          Duration(days: DateTime(createdAt.year, createdAt.month + 1, 0).day);
    } else if (periodType == 'Yearly') {
      firstPeriodLength = Duration(
        days: DateTime(createdAt.year + 1, createdAt.month, createdAt.day)
            .difference(createdAt)
            .inDays,
      );
    }

    endOfCurrentPeriod =
        createdAt.add(firstPeriodLength).subtract(const Duration(days: 1));

    if (today.isBefore(endOfCurrentPeriod)) {
      return BudgetPeriod(startOfCurrentPeriod, endOfCurrentPeriod);
    }

    if (periodType == 'Weekly') {
      final weeksSinceCreation = (timeSinceCreation.inDays / 7).floor();
      startOfCurrentPeriod = createdAt.add(
        Duration(days: weeksSinceCreation * 7),
      );
      endOfCurrentPeriod = startOfCurrentPeriod.add(
        const Duration(days: 6),
      );
    } else if (periodType == 'Bi-weekly') {
      final biWeeksSinceCreation = (timeSinceCreation.inDays / 14).floor();
      startOfCurrentPeriod =
          createdAt.add(Duration(days: biWeeksSinceCreation * 14));
      endOfCurrentPeriod = startOfCurrentPeriod.add(
        const Duration(days: 13),
      );
    } else if (periodType == 'Monthly') {
      final monthsSinceCreation =
          ((today.year - createdAt.year) * 12) + today.month - createdAt.month;
      startOfCurrentPeriod = DateTime(
        createdAt.year,
        createdAt.month + monthsSinceCreation,
        createdAt.day,
      );
      endOfCurrentPeriod = DateTime(
        createdAt.year,
        createdAt.month + monthsSinceCreation + 1,
        createdAt.day,
      ).subtract(
        const Duration(days: 1),
      );
    } else if (periodType == 'Yearly') {
      final yearsSinceCreation = today.year - createdAt.year;
      startOfCurrentPeriod = DateTime(
        createdAt.year + yearsSinceCreation,
        createdAt.month,
        createdAt.day,
      );
      endOfCurrentPeriod = DateTime(
        createdAt.year + yearsSinceCreation + 1,
        createdAt.month,
        createdAt.day,
      ).subtract(
        const Duration(days: 1),
      );
    }

    return BudgetPeriod(startOfCurrentPeriod, endOfCurrentPeriod);
  }
}
