import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crianza_mutua/screens/screens.dart';

class CommonDialog extends StatelessWidget {
  final String title;
  final String content;

  const CommonDialog({
    Key key,
    @required this.title,
    @required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _showIOSDialog(context)
        : _showAndroidDialog(context);
  }

  CupertinoAlertDialog _showIOSDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          child: const Text('Ok'),
          onPressed: () =>
              Navigator.of(context).pushNamed(LoginScreen.routeName),
        ),
      ],
    );
  }

  AlertDialog _showAndroidDialog(BuildContext context) {
    return AlertDialog(
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          child: const Text('Ok'),
          onPressed: () =>
              Navigator.of(context).pushNamed(LoginScreen.routeName),
        ),
      ],
    );
  }
}
