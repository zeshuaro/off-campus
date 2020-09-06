import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/models.dart';

export 'models/models.dart';

/// Thrown during the logout process if a failure occurs.
class SignOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthRepo {
  final FirebaseAuth _firebaseAuth;
  final _usersRef = FirebaseFirestore.instance.collection('users');

  /// {@macro authentication_repository}
  AuthRepo({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user => _firebaseAuth.authStateChanges();

  Future<MyUser> fetchMyUser(String userId) async {
    MyUser user;
    final docRef = await _usersRef.doc(userId).get();

    if (docRef.exists) {
      final data = docRef.data();
      data['id'] = userId;
      user = MyUser.fromJson(data);
    }

    return user;
  }

  /// Creates a new user with the provided [email] and [password].
  Future<void> register(String email, String password, String university,
      String faculty, String degree) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _usersRef.doc(credential.user.uid).set(<String, dynamic>{
      'university': university,
      'faculty': faculty,
      'degree': degree,
    });
  }

  /// Signs in with the provided [email] and [password].
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
