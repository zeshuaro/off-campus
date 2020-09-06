import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:offcampus/blocs/auth/auth.dart';
import 'package:formz/formz.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';

part 'register_cubit.g.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._authRepo)
      : assert(_authRepo != null),
        super(const RegisterState());

  final AuthRepo _authRepo;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        email,
        state.password,
        state.uniName,
        state.faculty,
      ]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([
        state.email,
        password,
        state.uniName,
        state.faculty,
      ]),
    ));
  }

  void uniNameChanged(String value) {
    final uniName = UniName.dirty(value);
    emit(state.copyWith(
      uniName: uniName,
      status: Formz.validate([
        state.email,
        state.password,
        uniName,
        state.faculty,
      ]),
    ));
  }

  void facultyChanged(String value) {
    final faculty = Faculty.dirty(value);
    emit(state.copyWith(
      faculty: faculty,
      status: Formz.validate([
        state.email,
        state.password,
        state.uniName,
        faculty,
      ]),
    ));
  }

  Future<void> RegisterFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(
        status: FormzStatus.submissionInProgress, errorMessage: ''));
    try {
      await _authRepo.register(state.email.value, state.password.value);
      emit(state.copyWith(
          status: FormzStatus.submissionSuccess, errorMessage: ''));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.message));
    } on Exception {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        errorMessage: 'Failed to register, please try again',
      ));
    }
  }
}
