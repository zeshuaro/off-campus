import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
  StreamSubscription<MyUser> _userSubscription;

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthUserChanged) {
      yield _mapAuthUserChangedToState(event);
    } else if (event is AuthSignOutRequested) {
      unawaited(_authRepo.signOut());
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  AuthState _mapAuthUserChangedToState(AuthUserChanged event) {
    return event.user != MyUser.empty
        ? AuthState.authenticated(event.user)
        : const AuthState.unauthenticated();
  }
}
