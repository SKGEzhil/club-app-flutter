import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({super.key, required this.onPressed, required this.buttonText, required this.textColor, required this.buttonColor, this.preceedingIcon});

  final VoidCallback onPressed;
  final String buttonText;
  final Color textColor;
  final Color buttonColor;
  final preceedingIcon;

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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              preceedingIcon == null ? SizedBox() :
              Icon(preceedingIcon,
                color: textColor,
                size: 18,
              ),
              preceedingIcon == null ? SizedBox() :
              const SizedBox(
                width: 5,
              ),
              Text(
                buttonText,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
