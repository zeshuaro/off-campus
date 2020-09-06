import 'package:formz/formz.dart';
import 'package:string_validator/string_validator.dart';

enum EmailValidationError { invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidationError validator(String value) {
    return isEmail(value) ? null : EmailValidationError.invalid;
  }
}
