import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({super.key, required this.onPressed, required this.buttonText, required this.textColor, required this.buttonColor});

  final VoidCallback onPressed;
  final String buttonText;
  final Color textColor;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              50)),
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(
                50)),
        child: Padding(
          padding:
          const EdgeInsets.fromLTRB(15, 6, 15, 6),
          child: Text(
            buttonText,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}
