import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:offcampus/blocs/blocs.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._authRepo)
      : assert(_authRepo != null),
        super(const SignInState());

  final AuthRepo _authRepo;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    ));
  }

  Future<void> signInWithCredentials() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(
        status: FormzStatus.submissionInProgress, errorMessage: ''));
    try {
      await _authRepo.signInWithEmailAndPassword(
          state.email.value, state.password.value);
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.message));
    } on Exception {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        errorMessage: 'Failed to sign in, please try again',
      ));
    }
  }
}
