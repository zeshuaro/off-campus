import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:offcampus/app.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';
import 'package:offcampus/repos/chat/chat_repo.dart';
import 'package:offcampus/repos/uni/uni_repo.dart';
import 'package:offcampus/repos/user/user_repo.dart';
import 'package:offcampus/simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();

  final authRepo = AuthRepo();
  runApp(App(
    authRepo: authRepo,
    uniRepo: UniRepo(),
    userRepo: UserRepo(),
    chatRepo: ChatRepo(authRepo),
  ));
}
