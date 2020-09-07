import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

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
  final _storageRef = FirebaseStorage.instance.ref();
  final _uuid = Uuid();

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
  Future<void> register({
    @required String email,
    @required String password,
    String name,
    String university,
    String faculty,
    String degree,
  }) async {
    assert(email != null);
    assert(password != null);

    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _usersRef.doc(credential.user.uid).set(<String, dynamic>{
      'name': name,
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

  Future<MyUser> updateProfile(String userId,
      {File image, String summary}) async {
    if (image != null) {
      final imageData = await image.readAsBytes();
      final refPath = 'users/${_uuid.v4()}${p.extension(image.path)}';
      final ref = _storageRef.child(refPath);
      final metadata = StorageMetadata(contentType: lookupMimeType(refPath));

      final uploadTask = ref.putData(imageData, metadata);
      await uploadTask.onComplete;

      await _usersRef.doc(userId).update(<String, dynamic>{'image': refPath});
    }

    final summaryText = summary ?? '';
    await _usersRef
        .doc(userId)
        .update(<String, dynamic>{'summary': summaryText});
    final user = await fetchMyUser(userId);

    return user;
  }
}
