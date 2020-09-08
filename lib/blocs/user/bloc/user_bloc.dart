import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';
import 'package:offcampus/repos/user/user_repo.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepo _userRepo;
  UserBloc(this._userRepo) : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is FetchUsers) {
      yield* _mapFetchUsersToState(event);
    }
  }

  Stream<UserState> _mapFetchUsersToState(FetchUsers event) async* {
    final currState = state;
    if (currState is UserInitial) {
      try {
        final users = await _userRepo.fetchUsers(event.currUserId);
        yield UserSuccess(users);
      } catch (_) {
        yield UserFailure();
      }
    }
  }
}
