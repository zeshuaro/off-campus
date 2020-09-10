import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:offcampus/blocs/auth/auth.dart';
import 'package:offcampus/blocs/chat/chat.dart';
import 'package:offcampus/blocs/message/message.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/repos/auth/models/user.dart';
import 'package:offcampus/repos/chat/chat_repo.dart';
import 'package:offcampus/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  static Route route(Chat chat, String title) {
    return MaterialPageRoute(
      builder: (context) => ChatPage(chat: chat, title: title),
    );
  }

  final Chat chat;
  final String title;

  const ChatPage({Key key, @required this.chat, @required this.title})
      : assert(chat != null),
        assert(title != null),
        super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  MyUser _user;
  Chat _chat;
  MessageBloc _messageBloc;

  @override
  void initState() {
    super.initState();
    _user = context.bloc<AuthBloc>().state.user;
    _chat = widget.chat;
    _messageBloc = context.bloc<MessageBloc>()..add(LoadMessages(_chat.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.black)),
        backgroundColor: kYellow,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state is MessageLoaded) {
            return DashChat(
              key: _chatViewKey,
              inverted: false,
              onSend: _onSend,
              sendOnEnter: true,
              textInputAction: TextInputAction.send,
              user: ChatUser(uid: _user.id, name: _user.name),
              inputDecoration:
                  InputDecoration.collapsed(hintText: 'Add message here...'),
              inputFooterBuilder: () => SafeArea(child: SizedBox()),
              dateFormat: DateFormat('yyyy-MMM-dd'),
              timeFormat: DateFormat('HH:mm'),
              messages: state.messages.map((message) {
                return ChatMessage(
                  id: message.id,
                  text: message.text,
                  user: ChatUser(
                    uid: message.user.id,
                    name: message.user.name,
                  ),
                );
              }).toList(),
              showUserAvatar: false,
              showAvatarForEveryMessage: false,
              scrollToBottom: false,
              inputMaxLines: 5,
              messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
              alwaysShowSend: true,
              inputTextStyle: TextStyle(fontSize: 16.0),
              inputContainerStyle: BoxDecoration(
                border: Border.all(width: 0.0),
                color: Colors.white,
              ),
              shouldShowLoadEarlier: false,
              showTraillingBeforeSend: false,
              onLoadEarlier: () {},
            );
          }

          return LoadingWidget();
        },
      ),
    );
  }

  void _onSend(ChatMessage message) {
    if (_chat.isInit) {
      context
          .bloc<ChatBloc>()
          .add(AddChat(_chat.users.map((user) => user.id).toList()));
      _chat = _chat.copyWith(isInit: false);
    }
    _messageBloc.add(AddMessage(_user.id, _chat.id, message.text));
  }
}
