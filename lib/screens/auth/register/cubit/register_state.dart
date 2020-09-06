part of 'register_cubit.dart';

@CopyWith()
class RegisterState extends Equatable {
  final Email email;
  final Password password;
  final Name name;
  final UniName uniName;
  final Faculty faculty;
  final Degree degree;
  final FormzStatus status;
  final String errorMessage;

  const RegisterState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.name = const Name.pure(),
    this.uniName = const UniName.pure(),
    this.faculty = const Faculty.pure(),
    this.degree = const Degree.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage = '',
  });

  @override
  List<Object> get props {
    return [
      email,
      password,
      name,
      uniName,
      faculty,
      degree,
      status,
      errorMessage,
    ];
  }
}
