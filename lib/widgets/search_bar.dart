import 'package:flutter/material.dart';
import 'package:offcampus/widgets/widgets.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function onChanged;
  final String hintText;

  SearchBar({Key key, this.controller, this.onChanged, this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      onChanged: onChanged,
      controller: controller,
      fillColor: Colors.white,
      isHighlightBorder: false,
      hintText: hintText,
      helperText: null,
    );
  }
}
