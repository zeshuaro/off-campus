import 'package:flutter/material.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/screens/complete_profile/view/complete_profile_form.dart';

class CompleteProfilePage extends StatelessWidget {
  static Route route() => MaterialPageRoute(
        builder: (_) => CompleteProfilePage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kYellow,
      appBar: AppBar(
        title: Text('Complete Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        elevation: 0.0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: CompleteProfileForm(),
        ),
      ),
    );
  }
}
