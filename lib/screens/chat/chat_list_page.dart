import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offcampus/blocs/auth/auth.dart';
import 'package:offcampus/blocs/chat/chat.dart';
import 'package:offcampus/widgets/widgets.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    final _user = context.bloc<AuthBloc>().state.user;
    context.bloc<ChatBloc>()..add(LoadChats(_user.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoaded) {
          return ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    state.chats[index].title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: state.chats.length,
          );
        }

        return LoadingWidget();
      },
    );
  }
}
