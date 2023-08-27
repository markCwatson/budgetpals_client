import 'package:formz/formz.dart';

enum CategoryFormValidationError { empty }

class CategoryForm extends FormzInput<String, CategoryFormValidationError> {
  const CategoryForm.pure() : super.pure('None Selected');
  const CategoryForm.dirty([super.value = '']) : super.dirty();

  @override
  CategoryFormValidationError? validator(String value) {
    if (value.isEmpty) return CategoryFormValidationError.empty;
    if (value == 'None Selected') return CategoryFormValidationError.empty;
    return null;
  }
}
