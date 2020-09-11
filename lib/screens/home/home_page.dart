import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager_firebase/flutter_cache_manager_firebase.dart';
import 'package:offcampus/blocs/blocs.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';
import 'package:offcampus/repos/chat/chat_repo.dart';
import 'package:offcampus/screens/chat/chat_page.dart';
import 'package:offcampus/widgets/widgets.dart';
import 'package:slimy_card/slimy_card.dart';

class HomePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final user = context.bloc<AuthBloc>().state.user;
    context.bloc<UserBloc>()..add(LoadUsers(user.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return state.users.isNotEmpty
              ? ListView.separated(
                  padding: kLayoutPadding,
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    return _UserCard(user: state.users[index]);
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 36),
                )
              : Center(
                  child: Text(
                    'Looks like you\'ve started a conversation with every single member on OffCampus!',
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

class _UserCard extends StatelessWidget {
  final MyUser user;

  const _UserCard({Key key, @required this.user})
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
          child: CachedNetworkImage(
            cacheManager: FirebaseCacheManager(),
            width: 150.0,
            height: 150.0,
            imageUrl: user.image,
            fit: BoxFit.cover,
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
      onPressed: () {
        final currUser = context.bloc<AuthBloc>().state.user;
        final chatId = currUser.id + user.id;
        final chat = Chat(
          id: chatId,
          type: ChatType.private,
          userIds: <String>[currUser.id, user.id],
          title: user.name,
        );

        Navigator.of(context).push(ChatPage.route(chat));
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
