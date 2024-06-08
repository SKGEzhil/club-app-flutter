import 'package:club_app/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class CustomAlertDialogue extends AlertDialog {
  CustomAlertDialogue(
      {super.key,
      required this.context,
      required this.onPressed,
      required String title,
      required String content})
      : super(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            ButtonWidget(
                onPressed: () {
                  Navigator.pop(context);
                },
                buttonText: 'Cancel',
                textColor: Colors.red,
                buttonColor: Colors.red.withOpacity(0.1)),
            ButtonWidget(
                onPressed: onPressed,
                buttonText: 'OK',
                textColor: Colors.blue,
                buttonColor: Colors.blue.withOpacity(0.1)),
          ],
        );

  final BuildContext context;
  final VoidCallback onPressed;
}
