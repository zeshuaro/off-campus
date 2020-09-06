import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offcampus/blocs/auth/auth.dart';
import 'package:offcampus/blocs/uni/uni.dart';
import 'package:offcampus/repos/uni/uni_repo.dart';
import 'package:offcampus/screens/home/home.dart';
import 'package:offcampus/screens/auth/sign_in/sign_in.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';
import 'package:offcampus/screens/splash_page.dart';
import 'package:offcampus/theme.dart';

class App extends StatelessWidget {
  final AuthRepo authRepo;
  final UniRepo uniRepo;

  const App({
    Key key,
    @required this.authRepo,
    @required this.uniRepo,
  })  : assert(authRepo != null),
        assert(uniRepo != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authRepo,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(authRepo: authRepo)),
          BlocProvider(create: (_) => UniBloc(uniRepo)),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    context.bloc<UniBloc>().add(FetchUnis());
  }

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                  (route) => false,
                );
                break;
              case AuthStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  SignInPage.route(),
                  (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
