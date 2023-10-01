import 'package:formz/formz.dart';

enum FrequencyFormValidationError { empty }

class FrequencyForm extends FormzInput<String, FrequencyFormValidationError> {
  const FrequencyForm.pure() : super.pure('None Selected');
  const FrequencyForm.dirty([super.value = '']) : super.dirty();

  @override
  FrequencyFormValidationError? validator(String value) {
    if (value.isEmpty) return FrequencyFormValidationError.empty;
    if (value == 'None Selected') return FrequencyFormValidationError.empty;
    return null;
  }
}
