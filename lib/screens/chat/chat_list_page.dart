import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offcampus/blocs/blocs.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';
import 'package:offcampus/screens/chat/chat_page.dart';
import 'package:offcampus/widgets/widgets.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  MyUser _user;

  @override
  void initState() {
    super.initState();
    _user = context.bloc<AuthBloc>().state.user;
    context.bloc<ChatBloc>()..add(LoadChats(_user.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoaded) {
          return ListView.separated(
            itemBuilder: (context, index) {
              final chat = state.chats[index];
              final lastMessageUser = chat.lastMessageUser == _user.name
                  ? ''
                  : '${chat.lastMessageUser}: ';

              return Container(
                color: Colors.white,
                child: ListTile(
                  onTap: () => Navigator.of(context).push(ChatPage.route(chat)),
                  title: Text(
                    chat.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    '$lastMessageUser${chat.lastMessage}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
              height: 0,
              color: Colors.black,
            ),
            itemCount: state.chats.length,
          );
        }

        return LoadingWidget();
      },
    );
  }
}
