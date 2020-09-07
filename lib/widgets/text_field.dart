import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final Function onChanged;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData iconData;
  final String labelText;
  final String errorText;

  const MyTextField({
    Key key,
    this.onChanged,
    this.textInputAction,
    this.keyboardType,
    this.obscureText = false,
    this.iconData,
    this.labelText,
    this.errorText,
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
      onChanged: widget.onChanged,
      onSubmitted: widget.textInputAction == TextInputAction.next
          ? (value) => FocusScope.of(context).nextFocus()
          : null,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderSide: _isFocused ? BorderSide() : BorderSide.none,
          borderRadius: BorderRadius.circular(30.0),
        ),
        contentPadding: EdgeInsets.zero,
        prefixIcon: widget.iconData != null ? Icon(widget.iconData) : null,
        labelText: widget.labelText,
        helperText: '',
        errorText: widget.errorText,
      ),
    );
  }
}
