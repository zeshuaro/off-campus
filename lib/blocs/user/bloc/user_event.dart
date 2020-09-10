part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {
  final String currUserId;

  LoadUsers(this.currUserId);

  @override
  List<Object> get props => [currUserId];
}

class UpdateUsers extends UserEvent {
  final List<MyUser> users;

  UpdateUsers(this.users);

  @override
  List<Object> get props => [users];
}
