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

  @override
  String toString() => 'UpdateUsers: { user: ${users.length} }';
}

class SearchUsers extends UserEvent {
  final String keyword;

  SearchUsers(this.keyword);

  @override
  List<Object> get props => [keyword];
}

class FilterUsers extends UserEvent {
  final String university;
  final String faculty;

  FilterUsers({this.university, this.faculty});

  @override
  List<Object> get props => [university, faculty];
}
