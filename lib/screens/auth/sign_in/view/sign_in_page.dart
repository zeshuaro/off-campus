import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offcampus/screens/auth/sign_in/sign_in.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';

class SignInPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SignInPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: BlocProvider(
            create: (_) => SignInCubit(context.repository<AuthRepo>()),
            child: SignInForm(),
          ),
        ),
      ),
    );
  }
}
