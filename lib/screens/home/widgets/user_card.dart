import 'package:flutter/material.dart';
import 'package:offcampus/blocs/blocs.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';
import 'package:offcampus/repos/chat/chat_repo.dart';
import 'package:offcampus/screens/chat/chat.dart';
import 'package:offcampus/widgets/widgets.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCard extends StatelessWidget {
  final MyUser user;

  const UserCard({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlimyCard(
      color: Colors.amber[200],
      width: MediaQuery.of(context).size.width,
      topCardHeight: 420,
      bottomCardHeight: 150,
      borderRadius: 15,
      topCardWidget: _TopCardWidget(user: user),
      bottomCardWidget: _BottomCardWidget(summary: user.summary),
    );
  }
}

class _TopCardWidget extends StatelessWidget {
  final MyUser user;

  const _TopCardWidget({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetPadding(),
        ClipOval(
          child: MyCachedNetworkImage(
            imageUrl: user.image,
            width: 150,
            height: 150,
          ),
        ),
        WidgetPadding(),
        Text(
          user.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .headline5
              .apply(color: Colors.black, fontWeightDelta: 2),
        ),
        WidgetPaddingSm(),
        Text(
          user.degree,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
        WidgetPaddingSm(),
        Text(
          user.university,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        WidgetPaddingSm(),
        _SendMessageButton(user: user),
      ],
    );
  }
}

class _SendMessageButton extends StatelessWidget {
  final MyUser user;

  const _SendMessageButton({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () async {
        final currUser = context.bloc<AuthBloc>().state.user;
        final chatId = currUser.id + user.id;
        final chat = Chat(
          id: chatId,
          type: ChatType.private,
          userIds: <String>[currUser.id, user.id],
          title: user.name,
        );

        await Navigator.of(context).push(ChatPage.route(chat));
        context.bloc<MessageBloc>().add(InitMessages());
      },
      color: Theme.of(context).primaryColor,
      shape: StadiumBorder(),
      child: Text(
        'Send Message',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class _BottomCardWidget extends StatelessWidget {
  final String summary;

  const _BottomCardWidget({Key key, @required this.summary})
      : assert(summary != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ListView(
        padding: kLayoutPadding,
        children: [
          Text(
            'About Me',
            style:
                Theme.of(context).textTheme.subtitle1.apply(fontWeightDelta: 1),
          ),
          Text(summary),
        ],
      ),
    );
  }
}
