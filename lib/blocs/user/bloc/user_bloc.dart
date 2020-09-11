import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';
import 'package:offcampus/repos/user/user_repo.dart';

part 'user_bloc.g.dart';

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
    } else if (event is SearchUsers) {
      yield* _mapSearchUsersToState(event);
    }
  }

  Stream<UserState> _mapLoadUsersToState(LoadUsers event) async* {
    await _usersSubscription?.cancel();
    _usersSubscription = _userRepo.users(event.currUserId).listen(
          (users) => add(UpdateUsers(users)),
        );
  }

  Stream<UserState> _mapUpdateUsersToState(UpdateUsers event) async* {
    yield UserLoaded(users: event.users);
  }

  Stream<UserState> _mapSearchUsersToState(SearchUsers event) async* {
    final currState = state;
    if (currState is UserLoaded) {
      final users = List<MyUser>.from(currState.users)
          .where((user) => user.name.toLowerCase().contains(event.keyword))
          .toList();
      yield currState.copyWith(searchResults: users);
    }
  }
}
