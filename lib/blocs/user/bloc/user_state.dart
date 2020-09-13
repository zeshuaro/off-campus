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
  final List<MyUser> filteredResults;

  UserLoaded({@required this.users, this.filteredResults = const <MyUser>[]})
      : assert(users != null);

  @override
  List<Object> get props => [users, filteredResults];

  @override
  String toString() =>
      'UserLoaded: { users: ${users.length}, searchResults: ${filteredResults.length} }';
}
