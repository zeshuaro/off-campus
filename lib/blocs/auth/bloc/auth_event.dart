part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  final MyUser user;

  @override
  List<Object> get props => [user];
}

class AuthSignOutRequested extends AuthEvent {}
