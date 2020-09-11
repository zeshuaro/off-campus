import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/screens/auth/sign_in/sign_in.dart';
import 'package:offcampus/screens/auth/register/register.dart';
import 'package:formz/formz.dart';
import 'package:offcampus/widgets/widgets.dart';

class SignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Off Campus', style: Theme.of(context).textTheme.headline3),
          WidgetPadding(),
          MyCard(
            child: Padding(
              padding: kLayoutPadding,
              child: Column(
                children: [
                  WidgetPaddingSm(),
                  _EmailInput(),
                  WidgetPaddingSm(),
                  _PasswordInput(),
                  WidgetPaddingSm(),
                  _SignInButton(),
                  WidgetPaddingSm(),
                  _RegisterButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return MyTextField(
          onChanged: (email) => context.bloc<SignInCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          prefixIcon: Icon(Icons.email),
          labelText: 'Email',
          errorText: state.email.invalid ? 'Invalid email' : null,
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return MyTextField(
          onChanged: (password) =>
              context.bloc<SignInCubit>().passwordChanged(password),
          obscureText: true,
          prefixIcon: Icon(Icons.lock),
          labelText: 'Password',
          errorText: state.password.invalid
              ? 'Password must be at least 8 characters with at least one letter and one digit'
              : null,
        );
      },
    );
  }
}

class _SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                height: 36.0,
                child: RaisedButton(
                  child: const Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: StadiumBorder(),
                  color: Theme.of(context).primaryColor,
                  onPressed: state.status.isValidated
                      ? () =>
                          context.bloc<SignInCubit>().signInWithCredentials()
                      : null,
                ),
              );
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      shape: StadiumBorder(),
      child: Text('Register'),
      onPressed: () => Navigator.of(context).push<void>(RegisterPage.route()),
    );
  }
}
