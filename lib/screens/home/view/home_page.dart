import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offcampus/blocs/blocs.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/repos/uni/uni_repo.dart';
import 'package:offcampus/screens/home/widgets/widgets.dart';
import 'package:offcampus/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textController = TextEditingController();
  UserBloc _userBloc;
  List<Uni> _unis;
  final _uniNames = <String>[kAllKeyword];
  Uni _uni;
  String _uniName = kAllKeyword;
  String _faculty = kAllKeyword;

  @override
  void initState() {
    super.initState();
    final user = context.bloc<AuthBloc>().state.user;
    _userBloc = context.bloc<UserBloc>()..add(LoadUsers(user.id));
    _unis = context.bloc<UniBloc>().state.unis;
    _uniNames.addAll(_unis.map((uni) => uni.name));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          var users = state.users;
          if (_textController.text?.isNotEmpty == true ||
              _uniName != kAllKeyword ||
              _faculty != kAllKeyword) {
            users = state.filteredResults;
          }

          return Padding(
            padding: kLayoutPadding,
            child: Column(
              children: [
                SearchBar(
                  controller: _textController,
                  hintText: 'Search for users',
                  onChanged: (String string) {
                    _userBloc.add(SearchUsers(string));
                  },
                  clearTextCallback: () {
                    _userBloc.add(
                      FilterUsers(university: _uniName, faculty: _faculty),
                    );
                  },
                ),
                WidgetPaddingSm(),
                Expanded(
                  child: users.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          itemCount: users.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return FlatButton(
                                onPressed: () => FilterBottomSheet.show(
                                  context: context,
                                  uniOptions: _uniNames,
                                  uniCallback: _setUni,
                                  selectedUni: _uniName,
                                  facultyOptions:
                                      _uni != null ? _uni.allFaculties : null,
                                  facultyCallback: _setFaculty,
                                  selectedFaculty: _faculty,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Filter',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    Icon(Icons.arrow_drop_down,
                                        color: Colors.black54),
                                  ],
                                ),
                              );
                            } else {
                              return UserCard(user: users[index - 1]);
                            }
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: index == 0 ? 16 : 36),
                        )
                      : Center(
                          child: Text(
                            'No users found',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                ),
              ],
            ),
          );
        }

        return LoadingWidget();
      },
    );
  }

  void _setUni(String uniName) {
    setState(() {
      _uni = _unis.firstWhere(
        (element) => element.name == uniName,
        orElse: () => null,
      );
      _uniName = uniName;
      _faculty = kAllKeyword;
    });
    _userBloc.add(FilterUsers(university: uniName));
  }

  void _setFaculty(String faculty) {
    setState(() => _faculty = faculty);
    _userBloc.add(FilterUsers(faculty: faculty));
  }
}
