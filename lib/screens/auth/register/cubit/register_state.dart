part of 'register_cubit.dart';

class RegisterState extends Equatable {
  final Email email;
  final Password password;
  final FormzStatus status;
  final String errorMessage;

  const RegisterState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage = '',
  });

  @override
  List<Object> get props => [email, password, status, errorMessage];

  RegisterState copyWith({
    Email email,
    Password password,
    FormzStatus status,
    String errorMessage,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
