import 'package:formz/formz.dart';

enum PeriodValidationError { empty }

class Period extends FormzInput<String, PeriodValidationError> {
  const Period.pure() : super.pure('None Selected');
  const Period.dirty([super.value = '']) : super.dirty();

  @override
  PeriodValidationError? validator(String value) {
    if (value.isEmpty) return PeriodValidationError.empty;
    if (value == 'None Selected') return PeriodValidationError.empty;
    return null;
  }
}
