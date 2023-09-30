import 'package:formz/formz.dart';

enum DateValidationError { empty }

class Date extends FormzInput<String, DateValidationError> {
  const Date.pure() : super.pure('');
  const Date.dirty([super.value = '']) : super.dirty();

  @override
  DateValidationError? validator(String value) {
    if (value.isEmpty) return DateValidationError.empty;
    return null;
  }
}
