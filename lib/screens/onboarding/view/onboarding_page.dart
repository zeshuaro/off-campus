import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:offcampus/screens/complete_profile/view/complete_profile_page.dart';

class OnboardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width * 0.75;

    return IntroViewsFlutter(
      [
        PageViewModel(
          pageColor: const Color(0xFF03A9F4),
          mainImage: ClipOval(
            clipper: _MyClipper(),
            child: Image.asset(
              'assets/images/friends.png',
              width: imageSize,
              height: imageSize,
            ),
          ),
          title: Text('Friends'),
          body: Text(
            'Meet new friends from your degree, or across different universities and faculties',
          ),
          bubble: Center(
            child: FaIcon(
              FontAwesomeIcons.userFriends,
              color: const Color(0xFF03A9F4),
              size: 16,
            ),
          ),
        ),
        PageViewModel(
          pageColor: const Color(0xFF8BC34A),
          mainImage: ClipOval(
            clipper: _MyClipper(),
            child: Image.asset(
              'assets/images/study.png',
              width: imageSize,
              height: imageSize,
            ),
          ),
          title: Text('Study'),
          body: Text(
            'Join course chats to discuss about your enrolled courses',
          ),
          bubble: Center(
            child: FaIcon(
              FontAwesomeIcons.university,
              color: const Color(0xFF8BC34A),
              size: 16,
            ),
          ),
        ),
        PageViewModel(
          pageColor: const Color(0xFF607D8B),
          mainImage: ClipOval(
            clipper: _MyClipper(),
            child: Image.asset(
              'assets/images/chat.png',
              width: imageSize,
              height: imageSize,
            ),
          ),
          title: Text('Chat'),
          body: Text(
            'Chat with your friends and collegues',
          ),
          bubble: Center(
            child: FaIcon(
              FontAwesomeIcons.solidComment,
              color: const Color(0xFF607D8B),
              size: 16,
            ),
          ),
        ),
      ],
      showNextButton: true,
      showBackButton: true,
      showSkipButton: true,
      onTapDoneButton: () {
        Navigator.of(context).push(CompleteProfilePage.route());
      },
      onTapSkipButton: () {
        Navigator.of(context).push(CompleteProfilePage.route());
      },
      pageButtonTextStyles: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
    );
  }
}

class _MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}
