import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: AppBar(title: const Text('Register')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
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
    );
  }
}
