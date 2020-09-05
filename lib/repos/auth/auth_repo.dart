import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'models/models.dart';

export 'models/models.dart';

/// Thrown if during the sign up process if a failure occurs.
class RegisterFailure implements Exception {}

/// Thrown during the sign in process if a failure occurs.
class SignInFailure implements Exception {}

/// Thrown during the logout process if a failure occurs.
class SignOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthRepo {
  /// {@macro authentication_repository}
  AuthRepo({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<MyUser> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? MyUser.empty : firebaseUser.toUser;
    });
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [RegisterFailure] if an exception occurs.
  Future<void> register(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [SignInFailure] if an exception occurs.
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  /// Signs out the current user which will emit
  /// [MyUser.empty] from the [user] Stream.
  ///
  /// Throws a [SignOutFailure] if an exception occurs.
  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut()]);
    } on Exception {
      throw SignOutFailure();
    }
  }
}

extension on User {
  MyUser get toUser {
    return MyUser(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
