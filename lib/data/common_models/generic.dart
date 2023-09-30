/// An abstract class that serves as a blueprint for financial entries.
///
/// The FinanceEntry class provides a common interface that outlines the basic
/// properties required by any finance-related entry, such as an expense or an
/// income.
///
/// Classes that represent specific types of financial entries should implement
/// this interface to ensure that they adhere to the expected contract.
///
/// Example:
/// ```dart
/// class Expense implements FinanceEntry {
///   // implementation here
/// }
///
/// class Income implements FinanceEntry {
///   // implementation here
/// }
/// ```
abstract class FinanceEntry {
  String get id;
  String get category;
  String get date;
  double get amount;
}
