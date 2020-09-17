import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:offcampus/blocs/blocs.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/repos/auth/models/user.dart';
import 'package:offcampus/repos/chat/chat_repo.dart';
import 'package:offcampus/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  static Route route(Chat chat) {
    return MaterialPageRoute(
      builder: (context) => ChatPage(chat: chat),
    );
  }

  final Chat chat;

  const ChatPage({Key key, @required this.chat})
      : assert(chat != null),
        super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  MyUser _user;
  Chat _chat;
  ChatBloc _chatBloc;
  MessageBloc _messageBloc;

  @override
  void initState() {
    super.initState();
    _user = context.bloc<AuthBloc>().state.user;
    _chat = widget.chat;
    _chatBloc = context.bloc<ChatBloc>();
    _messageBloc = context.bloc<MessageBloc>()..add(LoadMessages(_chat.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.title, style: TextStyle(color: Colors.black)),
        backgroundColor: kYellow,
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state is MessageLoaded) {
            final isInitCourseChat =
                _chat.type == ChatType.course && _chat.isInit;

            return DashChat(
              key: _chatViewKey,
              inputDisabled: isInitCourseChat,
              inverted: false,
              onSend: _onSend,
              sendOnEnter: true,
              textInputAction: TextInputAction.send,
              user: ChatUser(uid: _user.id, name: _user.name),
              inputContainerStyle: BoxDecoration(
                border: Border(),
                color: Colors.grey[200],
              ),
              inputToolbarPadding: const EdgeInsets.symmetric(vertical: 4),
              inputDecoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              inputFooterBuilder: () => SafeArea(
                child: isInitCourseChat
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: _JoinChatButton(
                          chatId: _chat.id,
                          callback: _joinCourseChat,
                        ),
                      )
                    : SizedBox(),
              ),
              dateFormat: DateFormat('E, d MMM'),
              timeFormat: DateFormat('hh:mm a'),
              messages: state.messages.map((message) {
                return ChatMessage(
                  id: message.id,
                  text: message.text,
                  user: ChatUser(
                    uid: message.userId,
                    name: message.username,
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
              shouldShowLoadEarlier: false,
              showTraillingBeforeSend: false,
              onLoadEarlier: () {},
              sendButtonBuilder: _buildSendButton,
            );
          }

          return LoadingWidget();
        },
      ),
    );
  }

  Widget _buildSendButton(Function callback) {
    final isDisabled = _chat.type == ChatType.course && _chat.isInit;

    return RawMaterialButton(
      onPressed: isDisabled ? null : callback,
      constraints: BoxConstraints(minWidth: 35, minHeight: 35),
      child: Icon(Icons.send, color: Colors.white, size: 20),
      shape: CircleBorder(),
      fillColor: isDisabled ? Colors.grey : Colors.blue,
      elevation: 0,
    );
  }

  void _joinCourseChat() {
    setState(() => _chat = _chat.copyWith(isInit: false));
  }

  void _onSend(ChatMessage message) {
    _chat = _chat.copyWith(
      lastMessage: message.text,
      lastMessageUser: message.user.name,
    );
    if (_chat.isInit) {
      _chat = _chat.copyWith(isInit: false);
      _chatBloc.add(AddChat(_chat));
      context.bloc<UserBloc>().add(LoadUsers(_user));
    } else {
      _chatBloc.add(UpdateChat(_chat));
    }

    _messageBloc.add(AddMessage(_user.id, _user.name, _chat.id, message.text));
  }
}

class _JoinChatButton extends StatelessWidget {
  final String chatId;
  final Function callback;

  const _JoinChatButton(
      {Key key, @required this.chatId, @required this.callback})
      : assert(chatId != null),
        assert(callback != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = context.bloc<AuthBloc>().state.user.id;

    return RaisedButton(
      onPressed: () {
        callback();
        context.bloc<CourseChatBloc>().add(JoinCourseChat(chatId, userId));
      },
      color: Theme.of(context).primaryColor,
      shape: StadiumBorder(),
      child: Text(
        'Join to send messages',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
