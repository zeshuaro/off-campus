import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[CircularProgressIndicator()],
      ),
    );
  }
}

class LoadingErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('Failed to load'),
          )
        ],
      ),
    );
  }
}
