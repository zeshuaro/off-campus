import 'package:flutter/material.dart';
import 'package:offcampus/blocs/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offcampus/screens/complete_profile/complete_profile.dart';
import 'package:offcampus/screens/home_page.dart';

class RootPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => RootPage());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.bloc<AuthBloc>().state.user;

    return user.summary != null ? HomePage() : CompleteProfilePage();
  }
}
