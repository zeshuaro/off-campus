part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserFailure extends UserState {}

class UserSuccess extends UserState {
  final List<MyUser> users;

  UserSuccess(this.users);

  @override
  List<Object> get props => [users];
}
