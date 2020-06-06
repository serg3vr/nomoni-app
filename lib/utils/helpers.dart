import 'package:flutter/material.dart';

void showMessage(BuildContext context, Map resp) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(resp['message']['title']),
        content: Text(resp['message']['content']),
        actions: <Widget>[
          FlatButton(child: Text('Ok'), onPressed: () {
            Navigator.pop(context);
          })
        ],
        elevation: 24.0,
      );
    },
    barrierDismissible: true
  );
}