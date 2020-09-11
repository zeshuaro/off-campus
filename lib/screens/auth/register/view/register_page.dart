import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';
import 'package:offcampus/screens/auth/register/register.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const RegisterPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kYellow,
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: BlocProvider<RegisterCubit>(
                create: (_) => RegisterCubit(
                  context.repository<AuthRepo>(),
                ),
                child: RegisterForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
