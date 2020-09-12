import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offcampus/blocs/blocs.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/repos/chat/chat_repo.dart';
import 'package:offcampus/screens/chat/chat_page.dart';
import 'package:offcampus/widgets/widgets.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    final user = context.bloc<AuthBloc>().state.user;
    context.bloc<ChatBloc>()..add(LoadChats(user.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoaded) {
          return state.chats.isNotEmpty
              ? ListView.separated(
                  itemBuilder: (context, index) {
                    return _ChatTile(chat: state.chats[index]);
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 0,
                    color: Colors.black,
                  ),
                  itemCount: state.chats.length,
                )
              : Center(
                  child: Text(
                    'No chats found',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                );
        }

        return LoadingWidget();
      },
    );
  }
}

class _ChatTile extends StatelessWidget {
  final Chat chat;

  const _ChatTile({Key key, @required this.chat})
      : assert(chat != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.bloc<AuthBloc>().state.user;
    final lastMessageUser =
        chat.lastMessageUser == user.name ? '' : '${chat.lastMessageUser}: ';

    return Material(
      child: Ink(
        color: Colors.white,
        child: InkWell(
          onTap: () => Navigator.of(context).push(ChatPage.route(chat)),
          child: Padding(
            padding: kLayoutPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        chat.title,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .apply(fontWeightDelta: 2),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        chat.dateTime,
                        textAlign: TextAlign.end,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .apply(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                Text(
                  '$lastMessageUser${chat.lastMessage}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
