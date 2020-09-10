import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:offcampus/blocs/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/screens/chat/chat_list_page.dart';
import 'package:offcampus/screens/home/home_page.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final int _chatsIndex = 1;
  int _currIndex = 0;

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
          _currIndex != _chatsIndex
              ? Container(
                  margin: const EdgeInsets.only(top: 100.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                )
              : Container(color: Colors.grey[100]),
          IndexedStack(
            index: _currIndex,
            children: [HomePage(), ChatListPage()],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidComment),
            title: Text('Chats'),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) => setState(() => _currIndex = index);
}
