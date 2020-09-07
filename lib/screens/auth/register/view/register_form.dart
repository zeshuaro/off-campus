import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:offcampus/blocs/uni/uni.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/repos/uni/uni_repo.dart';
import 'package:offcampus/screens/auth/register/register.dart';
import 'package:formz/formz.dart';
import 'package:offcampus/widgets/widgets.dart';

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
          child: MyCard(
            child: Padding(
              padding: kLayoutPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WidgetPaddingSm(),
                  _EmailInput(),
                  WidgetPaddingSm(),
                  _PasswordInput(),
                  WidgetPaddingSm(),
                  _NameInput(),
                  _SelectUniFaculty(),
                  _DegreeInput(),
                  WidgetPadding(),
                  _RegisterButton(),
                ],
              ),
            ),
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
        return MyTextField(
          onChanged: (email) {
            context.bloc<RegisterCubit>().emailChanged(email);
          },
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          icon: Icon(Icons.email),
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
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return MyTextField(
          onChanged: (password) =>
              context.bloc<RegisterCubit>().passwordChanged(password),
          obscureText: true,
          textInputAction: TextInputAction.next,
          icon: Icon(Icons.lock),
          labelText: 'Password',
          errorText: state.password.invalid
              ? 'Password must contain least 8 characters with at least one letter and one digit'
              : null,
        );
      },
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return MyTextField(
          onChanged: (name) => context.bloc<RegisterCubit>().nameChanged(name),
          icon: Icon(Icons.person),
          labelText: 'Name',
          errorText: state.name.invalid
              ? 'Name must contain least 3 characters'
              : null,
        );
      },
    );
  }
}

class _SelectUniFaculty extends StatefulWidget {
  @override
  _SelectUniFacultyState createState() => _SelectUniFacultyState();
}

class _SelectUniFacultyState extends State<_SelectUniFaculty> {
  List<Uni> _unis = <Uni>[];
  Uni _uni;
  String _uniName;
  String _faculty;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UniBloc, UniState>(
      builder: (context, state) {
        List<String> uniNames;
        if (state is UniSuccess) {
          _unis = state.unis;
          uniNames = _unis.map((uni) => uni.name).toList();
        }

        return Column(
          children: [
            SelectField(
              label: 'University',
              selected: _uniName,
              onTap: () => _onUniTap(uniNames),
            ),
            WidgetPadding(),
            SelectField(
              label: 'Faculty',
              selected: _faculty,
              onTap: _onFacultyTap,
            ),
            WidgetPadding(),
          ],
        );
      },
    );
  }

  void _onUniTap(List<String> uniNames) {
    if (uniNames != null) {
      MyBottomSheet.show(
        context: context,
        selected: _uniName,
        options: uniNames,
        callback: _setUni,
      );
    }
  }

  void _setUni(String uniName) {
    setState(() {
      _uni = _unis.firstWhere((element) => element.name == uniName);
      _uniName = uniName;
      _faculty = null;
    });
    context.bloc<RegisterCubit>().uniNameChanged(uniName);
  }

  void _onFacultyTap() {
    if (_uni != null) {
      MyBottomSheet.show(
        context: context,
        selected: _faculty,
        options: _uni.faculties,
        callback: _setFaculty,
      );
    } else {
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Please select a university first'),
        ));
    }
  }

  void _setFaculty(String faculty) {
    setState(() => _faculty = faculty);
    context.bloc<RegisterCubit>().facultyChanged(faculty);
  }
}

class _DegreeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.degree != current.degree,
      builder: (context, state) {
        return MyTextField(
          onChanged: (degree) =>
              context.bloc<RegisterCubit>().degreeChanged(degree),
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [FaIcon(FontAwesomeIcons.graduationCap, size: 20.0)],
          ),
          labelText: 'Degree',
          helperText: 'E.g. Bachelor of Software Engineering 3rd Year',
          errorText: state.degree.invalid
              ? 'Degree must contain at least 3 characters'
              : null,
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
                height: 36.0,
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
