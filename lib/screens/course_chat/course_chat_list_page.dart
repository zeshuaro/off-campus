import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offcampus/blocs/auth/auth.dart';
import 'package:offcampus/blocs/course_chat/course_chat.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';
import 'package:offcampus/repos/chat/chat_repo.dart';
import 'package:offcampus/widgets/widgets.dart';

class CourseChatListPage extends StatefulWidget {
  @override
  _CourseChatListPageState createState() => _CourseChatListPageState();
}

class _CourseChatListPageState extends State<CourseChatListPage> {
  MyUser _user;

  @override
  void initState() {
    super.initState();
    _user = context.bloc<AuthBloc>().state.user;
    context.bloc<CourseChatBloc>()..add(LoadCourseChats(_user.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseChatBloc, CourseChatState>(
      builder: (context, state) {
        if (state is CourseChatLoaded) {
          return ListView.builder(
            padding: kLayoutPadding,
            itemCount: state.chats.length,
            itemBuilder: (context, index) {
              return _CourseChatCard(chat: state.chats[index]);
            },
          );
        }

        return LoadingWidget();
      },
    );
  }
}

class _CourseChatCard extends StatelessWidget {
  final Chat chat;

  const _CourseChatCard({Key key, @required this.chat})
      : assert(chat != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: Padding(
        padding: kLayoutPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chat.title,
              style: Theme.of(context).textTheme.headline6,
            ),
            WidgetPaddingSm(),
            Row(
              children: [
                Icon(Icons.people, color: Colors.grey, size: 18),
                SizedBox(width: 4),
                Text(
                  '${chat.numMembers} • Last message ${chat.relativeUpdatedAt}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
