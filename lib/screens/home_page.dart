import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager_firebase/flutter_cache_manager_firebase.dart';
import 'package:offcampus/blocs/auth/auth.dart';
import 'package:offcampus/blocs/user/bloc/user_bloc.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';
import 'package:offcampus/widgets/widgets.dart';

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
    context.bloc<UserBloc>()..add(FetchUsers(user.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kYellow,
        appBar: AppBar(
          title: const Text('OffCampus', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.black),
              onPressed: () =>
                  context.bloc<AuthBloc>().add(AuthSignOutRequested()),
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 100.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
            ),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserFailure) {
                  return LoadingErrorWidget();
                } else if (state is UserSuccess) {
                  return ListView.builder(
                    padding: kLayoutPadding,
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      return _UserCard(user: state.users[index]);
                    },
                  );
                }

                return LoadingWidget();
              },
            )
          ],
        ));
  }
}

class _UserCard extends StatelessWidget {
  final MyUser user;

  const _UserCard({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: Container(
        padding: kLayoutPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      WidgetPaddingSm(),
                      Text(
                        user.university,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                ClipOval(
                  child: CachedNetworkImage(
                    cacheManager: FirebaseCacheManager(),
                    width: 100.0,
                    height: 100.0,
                    imageUrl: user.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            WidgetPadding(),
            Align(
              alignment: Alignment.center,
              child: Text(user.degree),
            ),
            WidgetPadding(),
            Text(
              'About Me',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(user.summary),
          ],
        ),
      ),
    );
  }
}
