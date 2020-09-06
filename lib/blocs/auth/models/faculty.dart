import 'package:formz/formz.dart';

enum FacultyValidationError { invalid }

class Faculty extends FormzInput<String, FacultyValidationError> {
  const Faculty.pure() : super.pure('');
  const Faculty.dirty([String value = '']) : super.dirty(value);

  @override
  FacultyValidationError validator(String value) {
    return value.isNotEmpty ? null : FacultyValidationError.invalid;
  }
}
