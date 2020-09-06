import 'package:formz/formz.dart';

enum UniValidationError { invalid }

class UniName extends FormzInput<String, UniValidationError> {
  const UniName.pure() : super.pure('');
  const UniName.dirty([String value = '']) : super.dirty(value);

  @override
  UniValidationError validator(String value) {
    return value.isNotEmpty ? null : UniValidationError.invalid;
  }
}
