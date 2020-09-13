import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offcampus/blocs/blocs.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';
import 'package:offcampus/repos/uni/uni_repo.dart';
import 'package:offcampus/screens/home/widgets/widgets.dart';
import 'package:offcampus/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textController = TextEditingController();
  final _uniNames = <String>[kAllKeyword];

  MyUser _user;
  UserBloc _userBloc;
  List<Uni> _unis;
  Uni _uni;
  String _uniName = kAllKeyword;
  String _faculty = kAllKeyword;
  String _sortBy = kMostSimilar;

  @override
  void initState() {
    super.initState();
    _user = context.bloc<AuthBloc>().state.user;
    _userBloc = context.bloc<UserBloc>()..add(LoadUsers(_user));
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
                _buildLayout(users),
              ],
            ),
          );
        }

        return LoadingWidget();
      },
    );
  }

  Widget _buildLayout(List<MyUser> users) {
    return Expanded(
      child: users.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              itemCount: users.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildFilterSortOptions();
                } else {
                  return UserCard(user: users[index - 1]);
                }
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: index == 0 ? 24 : 36);
              },
            )
          : Center(
              child: Text(
                'No users found',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
    );
  }

  Widget _buildFilterSortOptions() {
    var faculty = '';
    if (_faculty != kAllKeyword) {
      faculty = ' (Faculty of $_faculty)';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSortOptions(
          uniOptions: _uniNames,
          uniCallback: _setUni,
          selectedUni: _uniName,
          facultyOptions: _uni != null ? _uni.allFaculties : null,
          facultyCallback: _setFaculty,
          selectedFaculty: _faculty,
          sortBy: _sortBy,
          sortCallback: _setSortBy,
        ),
        _uniName != kAllKeyword
            ? Padding(
                padding: const EdgeInsets.only(left: 8, top: 16),
                child: Text(
                  'Showing users from $_uniName$faculty',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : SizedBox.shrink(),
      ],
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

  void _setSortBy(String sortBy) {
    setState(() => _sortBy = sortBy);
    _userBloc.add(SortUsers(_user, sortBy));
  }
}
