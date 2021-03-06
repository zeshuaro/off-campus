part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {
  final MyUser currUser;

  LoadUsers(this.currUser);

  @override
  List<Object> get props => [currUser];
}

class UpdateUsers extends UserEvent {
  final List<MyUser> users;

  UpdateUsers(this.users);

  @override
  List<Object> get props => [users];

  @override
  String toString() => 'UpdateUsers: { user: ${users.length} }';
}

class FilterUsers extends UserEvent {
  final String keyword;
  final String university;
  final String faculty;

  FilterUsers(this.keyword, this.university, this.faculty);

  @override
  List<Object> get props => [keyword, university, faculty];
}

class SortUsers extends UserEvent {
  final MyUser currUser;
  final String sortBy;

  SortUsers(this.currUser, this.sortBy);

  @override
  List<Object> get props => [currUser, sortBy];
}
