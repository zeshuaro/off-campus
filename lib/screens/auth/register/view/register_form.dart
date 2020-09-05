import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offcampus/screens/auth/register/register.dart';
import 'package:formz/formz.dart';

class RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _EmailInput(),
              _PasswordInput(),
              const SizedBox(height: 8.0),
              _RegisterButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) =>
              context.bloc<RegisterCubit>().emailChanged(email),
          onSubmitted: (value) => FocusScope.of(context).nextFocus(),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            icon: Icon(Icons.email),
            labelText: 'Email',
            helperText: '',
            errorText: state.email.invalid ? 'Invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (password) =>
              context.bloc<RegisterCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.lock),
            labelText: 'Password',
            helperText: '',
            errorText: state.password.invalid
                ? 'Password must be at least 8 characters with at least one letter and one digit'
                : null,
            errorMaxLines: 2,
          ),
        );
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: StadiumBorder(),
                  color: Theme.of(context).primaryColor,
                  onPressed: state.status.isValidated
                      ? () =>
                          context.bloc<RegisterCubit>().RegisterFormSubmitted()
                      : null,
                ),
              );
      },
    );
  }
}
