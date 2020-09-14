import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';
import 'package:offcampus/repos/user/user_repo.dart';
import 'package:string_similarity/string_similarity.dart';

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
    } else if (event is FilterUsers) {
      yield* _mapSearchUsersToState(event);
    } else if (event is SortUsers) {
      yield* _mapSortUsersToState(event);
    }
  }

  Stream<UserState> _mapLoadUsersToState(LoadUsers event) async* {
    await _usersSubscription?.cancel();
    _usersSubscription = _userRepo.users(event.currUser.id).listen(
      (users) {
        users.sort((a, b) => -_userComparator(a, b, event.currUser));
        add(UpdateUsers(users));
      },
    );
  }

  Stream<UserState> _mapUpdateUsersToState(UpdateUsers event) async* {
    yield UserLoaded(users: event.users);
  }

  Stream<UserState> _mapSearchUsersToState(FilterUsers event) async* {
    final currState = state;
    if (currState is UserLoaded) {
      final keyword = event.keyword.toLowerCase();
      final university = event.university;
      final faculty = event.faculty;

      // Filter users by keyword
      var users = List<MyUser>.from(currState.users).where((user) {
        return user.name.toLowerCase().contains(keyword) ||
            user.university.toLowerCase().contains(keyword) ||
            user.faculty.toLowerCase().contains(keyword) ||
            user.degree.toLowerCase().contains(keyword);
      }).toList();

      // Filter users by university
      if (university != null && university != kAllKeyword) {
        users = users.where((user) => user.university == university).toList();
      }

      // Filter users by faculty
      if (faculty != null && faculty != kAllKeyword) {
        users = users.where((user) => user.faculty == faculty).toList();
      }
      yield currState.copyWith(filteredResults: users);
    }
  }

  Stream<UserState> _mapSortUsersToState(SortUsers event) async* {
    final currState = state;
    if (currState is UserLoaded) {
      var users = List<MyUser>.from(currState.users);
      if (event.sortBy == kMostSimilar) {
        users.sort((a, b) => -_userComparator(a, b, event.currUser));
      } else if (event.sortBy == kLeastSimilar) {
        users.sort((a, b) => _userComparator(a, b, event.currUser));
      } else if (event.sortBy == kRandom) {
        users.shuffle();
      }
      yield currState.copyWith(users: users);
    }
  }

  int _userComparator(MyUser a, MyUser b, MyUser currUser) {
    return (a.university.similarityTo(currUser.university) +
            a.faculty.similarityTo(currUser.faculty) +
            a.degree.similarityTo(currUser.degree))
        .compareTo(b.university.similarityTo(currUser.university) +
            b.faculty.similarityTo(currUser.faculty) +
            b.degree.similarityTo(currUser.degree));
  }
}
