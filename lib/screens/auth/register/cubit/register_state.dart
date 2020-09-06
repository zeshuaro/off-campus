part of 'register_cubit.dart';

class RegisterState extends Equatable {
  final Email email;
  final Password password;
  final UniName uniName;
  final FormzStatus status;
  final String errorMessage;

  const RegisterState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.uniName = const UniName.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage = '',
  });

  @override
  List<Object> get props => [email, password, uniName, status, errorMessage];

  RegisterState copyWith({
    Email email,
    Password password,
    UniName uniName,
    FormzStatus status,
    String errorMessage,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      uniName: uniName ?? this.uniName,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
