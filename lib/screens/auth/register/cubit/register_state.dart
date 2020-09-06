part of 'register_cubit.dart';

@CopyWith()
class RegisterState extends Equatable {
  final Email email;
  final Password password;
  final UniName uniName;
  final Faculty faculty;
  final FormzStatus status;
  final String errorMessage;

  const RegisterState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.uniName = const UniName.pure(),
    this.faculty = const Faculty.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage = '',
  });

  @override
  List<Object> get props {
    return [email, password, uniName, faculty, status, errorMessage];
  }
}
