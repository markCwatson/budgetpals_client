import 'package:formz/formz.dart';

enum EndDateValidationError { empty }

class EndDate extends FormzInput<String, EndDateValidationError> {
  const EndDate.pure() : super.pure('');
  const EndDate.dirty([super.value = '']) : super.dirty();

  @override
  EndDateValidationError? validator(String value) {
    // no check
    return null;
  }
}
