import 'package:club_app/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class CustomAlertDialogue extends StatelessWidget {
  const CustomAlertDialogue({
    super.key,
    required this.context,
    required this.onPressed,
    required this.title,
    required this.content,
    this.icon,
    this.buttonText = 'OK',
    this.cancelText = 'Cancel',
  });

  final BuildContext context;
  final VoidCallback onPressed;
  final String title;
  final String content;
  final IconData? icon;
  final String buttonText;
  final String cancelText;

  // Custom accent color - yellowish shade
  static const Color accentColor = Color(0xFFF5C518);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with optional icon
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: accentColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Text(
                content,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Action buttons
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: ButtonWidget(
                      onPressed: () => Navigator.pop(context),
                      buttonText: cancelText,
                      isNegative: true,
                      height: 44,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ButtonWidget(
                      onPressed: () {
                        onPressed();
                        Navigator.pop(context);
                      },
                      buttonText: buttonText,
                      isNegative: false,
                      height: 44,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper method to show the dialog easily
Future<void> showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirm,
  IconData? icon,
  String? buttonText,
  String? cancelText,
}) {
  return showDialog(
    context: context,
    builder: (context) => CustomAlertDialogue(
      context: context,
      title: title,
      content: content,
      onPressed: onConfirm,
      icon: icon,
      buttonText: buttonText ?? 'OK',
      cancelText: cancelText ?? 'Cancel',
    ),
  );
}
