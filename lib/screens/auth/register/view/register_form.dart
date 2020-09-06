import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:offcampus/blocs/uni/uni.dart';
import 'package:offcampus/repos/uni/uni_repo.dart';
import 'package:offcampus/screens/auth/register/register.dart';
import 'package:formz/formz.dart';
import 'package:offcampus/widgets/bottom_sheet.dart';

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
              _SelectUniFaculty(),
              _DegreeInput(),
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
                ? 'Password must be contain least 8 characters with at least one letter and one digit'
                : null,
            errorMaxLines: 2,
          ),
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
            InkWell(
              onTap: uniNames != null
                  ? () => MyBottomSheet.show(
                        context: context,
                        selected: _uniName,
                        options: uniNames,
                        callback: _setUni,
                      )
                  : null,
              child: _SelectField(label: 'University', selected: _uniName),
            ),
            InkWell(
              onTap: _uni != null
                  ? () => MyBottomSheet.show(
                        context: context,
                        selected: _faculty,
                        options: _uni.faculties,
                        callback: _setFaculty,
                      )
                  : () => Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text('Select a university first'))),
              child: _SelectField(label: 'Faculty', selected: _faculty),
            ),
          ],
        );
      },
    );
  }

  void _setUni(String uniName) {
    setState(() {
      _uni = _unis.firstWhere((element) => element.name == uniName);
      _uniName = uniName;
      _faculty = null;
    });
    context.bloc<RegisterCubit>().uniNameChanged(uniName);
  }

  void _setFaculty(String faculty) {
    setState(() => _faculty = faculty);
    context.bloc<RegisterCubit>().facultyChanged(faculty);
  }
}

class _SelectField extends StatelessWidget {
  final String label;
  final String selected;

  const _SelectField({Key key, @required this.label, this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(selected ?? 'Select', style: TextStyle(color: Colors.grey)),
              Icon(Icons.arrow_drop_down, color: Colors.grey)
            ],
          )
        ],
      ),
    );
  }
}

class _DegreeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.degree != current.degree,
      builder: (context, state) {
        return TextField(
          onChanged: (degree) =>
              context.bloc<RegisterCubit>().degreeChanged(degree),
          decoration: InputDecoration(
            icon: FaIcon(FontAwesomeIcons.graduationCap),
            labelText: 'Degree',
            helperText: 'E.g. Bachelor of Software Engineering 3rd Year',
            errorText: state.degree.invalid
                ? 'Degree must contain at least 3 characters'
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
