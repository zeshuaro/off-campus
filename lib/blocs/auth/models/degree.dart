import 'package:formz/formz.dart';

enum DegreeValidationError { invalid }

class Degree extends FormzInput<String, DegreeValidationError> {
  const Degree.pure() : super.pure('');
  const Degree.dirty([String value = '']) : super.dirty(value);

  @override
  DegreeValidationError validator(String value) {
    return value.length >= 3 ? null : DegreeValidationError.invalid;
  }
}
