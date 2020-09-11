part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {}

@CopyWith()
class UserLoaded extends UserState {
  final List<MyUser> users;
  final List<MyUser> searchResults;

  UserLoaded({@required this.users, this.searchResults = const <MyUser>[]})
      : assert(users != null);

  @override
  List<Object> get props => [users, searchResults];

  @override
  String toString() =>
      'UserLoaded: { users: ${users.length}, searchResults: ${searchResults.length} }';
}
