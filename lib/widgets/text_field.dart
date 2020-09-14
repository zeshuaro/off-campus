import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final Function onChanged;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final String labelText;
  final String hintText;
  final String helperText;
  final String errorText;
  final Color fillColor;
  final bool isHighlightBorder;
  final TextEditingController controller;

  const MyTextField({
    Key key,
    this.onChanged,
    this.textInputAction,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.labelText,
    this.hintText,
    this.helperText = '',
    this.errorText,
    this.fillColor = const Color(0xffeeeeee),
    this.isHighlightBorder = true,
    this.controller,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      controller: widget.controller,
      onChanged: widget.onChanged,
      onSubmitted: widget.textInputAction == TextInputAction.next
          ? (value) => FocusScope.of(context).nextFocus()
          : null,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.fillColor,
        border: OutlineInputBorder(
          borderSide: widget.isHighlightBorder && _isFocused
              ? BorderSide()
              : BorderSide.none,
          borderRadius: BorderRadius.circular(30.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        hintText: widget.hintText,
        helperText: widget.helperText,
        errorText: widget.errorText,
        errorMaxLines: 2,
      ),
    );
  }
}
