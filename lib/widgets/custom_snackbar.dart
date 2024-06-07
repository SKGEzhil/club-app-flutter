
import 'package:flutter/material.dart';

class CustomSnackBar{

  CustomSnackBar({required String message, required Color color});

  static show(BuildContext context, {required String message, required Color color}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(customSnackBar(message: message, color: color));
  }

  static SnackBar customSnackBar({required String message, required Color color}) {
    return SnackBar(
      content: Text(message),
      elevation: 10.0,
      duration: const Duration(seconds: 3),
      showCloseIcon: true,
      closeIconColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: color,
    );
  }
}

