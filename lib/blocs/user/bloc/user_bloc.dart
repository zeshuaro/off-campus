import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';
import 'package:offcampus/repos/user/user_repo.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepo _userRepo;
  UserBloc(this._userRepo) : super(UserLoading());
  StreamSubscription _usersSubscription;

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is LoadUsers) {
      yield* _mapLoadUsersToState(event);
    } else if (event is UpdateUsers) {
      yield* _mapUpdateUsersToState(event);
    }
  }

  Stream<UserState> _mapLoadUsersToState(LoadUsers event) async* {
    await _usersSubscription?.cancel();
    _usersSubscription = _userRepo.users(event.currUserId).listen(
          (users) => add(UpdateUsers(users)),
        );
  }

  Stream<UserState> _mapUpdateUsersToState(UpdateUsers event) async* {
    yield UserLoaded(event.users);
  }
}
