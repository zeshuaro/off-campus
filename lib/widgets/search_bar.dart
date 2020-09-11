import 'package:flutter/material.dart';
import 'package:offcampus/widgets/widgets.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function onChanged;
  final String hintText;
  final Function clearTextCallback;

  SearchBar({
    Key key,
    this.controller,
    this.onChanged,
    this.hintText,
    this.clearTextCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      onChanged: onChanged,
      controller: controller,
      fillColor: Colors.white,
      isHighlightBorder: false,
      hintText: hintText,
      helperText: null,
      suffixIcon: controller?.text?.isNotEmpty == true
          ? IconButton(
              onPressed: () {
                controller.clear();
                FocusScope.of(context).unfocus();

                if (clearTextCallback != null) {
                  clearTextCallback();
                }
              },
              icon: Icon(Icons.cancel, color: Colors.grey),
            )
          : null,
    );
  }
}
