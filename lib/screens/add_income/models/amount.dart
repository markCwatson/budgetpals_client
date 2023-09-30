import 'package:formz/formz.dart';

enum AmountValidationError { empty }

class Amount extends FormzInput<double, AmountValidationError> {
  const Amount.pure() : super.pure(0);
  const Amount.dirty([super.value = 0]) : super.dirty();

  @override
  AmountValidationError? validator(double value) {
    if (value.isNaN) return AmountValidationError.empty;
    if (value.isInfinite) return AmountValidationError.empty;
    return null;
  }
}
