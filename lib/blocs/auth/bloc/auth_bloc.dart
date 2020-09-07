import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';
import 'package:pedantic/pedantic.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    @required AuthRepo authRepo,
  })  : assert(authRepo != null),
        _authRepo = authRepo,
        super(const AuthState.unknown()) {
    _userSubscription = _authRepo.user.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  final AuthRepo _authRepo;
  StreamSubscription<User> _userSubscription;

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthUserChanged) {
      yield* _mapAuthUserChangedToState(event);
    } else if (event is AuthSignOutRequested) {
      unawaited(_authRepo.signOut());
    } else if (event is UpdateProfile) {
      yield* _mapUpdateProfileToState(event);
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  Stream<AuthState> _mapAuthUserChangedToState(AuthUserChanged event) async* {
    MyUser user;
    if (event.user != null) {
      user = await _authRepo.fetchMyUser(event.user.uid);
    }

    if (user != null) {
      yield AuthState.authenticated(user);
    } else {
      yield const AuthState.unauthenticated();
    }
  }

  Stream<AuthState> _mapUpdateProfileToState(UpdateProfile event) async* {
    final user = await _authRepo.updateProfile(event.userId,
        image: event.image, summary: event.summary);
    if (user != null) {
      yield AuthState.authenticated(user);
    } else {
      yield const AuthState.unauthenticated();
    }
  }
}
