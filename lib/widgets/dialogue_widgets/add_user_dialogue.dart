import 'package:club_app/widgets/dialogue_widgets/custom_alert_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../controllers/clubs_controller.dart';
import '../../controllers/loading_controller.dart';
import '../button_widget.dart';
import '../custom_snackbar.dart';

class AddUserDialogue extends StatelessWidget {
  AddUserDialogue({super.key, this.clubId, required this.type});

  final adminController = Get.put(AdminController());
  final clubsController = Get.put(ClubsController());
  final emailController = TextEditingController();
  final loadingController = Get.put(LoadingController());

  final clubId;
  final String type;

  // Custom accent color - yellowish shade
  static const Color accentColor = Color(0xFFF5C518);

  Future<void> addAdminUser(context) async {
    loadingController.toggleLoading();
    final result = await adminController.updateUserRole(context, emailController.text, "admin");
    loadingController.toggleLoading();
    result['status'] == 'error'
        ? CustomSnackBar.show(context,
        message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
        message: result['message'], color: Colors.green);
  }

  Future<void> addClubUser(context) async {
    loadingController.toggleLoading();
    final result = await clubsController.addUserToClub(context, clubId, emailController.text);
    loadingController.toggleLoading();
    result['status'] == 'error'
        ? CustomSnackBar.show(context,
        message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
        message: result['message'], color: Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      type == 'admin' ? Icons.admin_panel_settings : Icons.group_add,
                      color: accentColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    type == 'admin' ? 'Add Admin User' : 'Add Club User',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (type != 'admin') ...[
                    const SizedBox(height: 8),
                    Text(
                      'Add a new member to your club',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            // Email Input
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter email address',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.onSurface.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: accentColor,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                style: theme.textTheme.bodyLarge,
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: ButtonWidget(
                      onPressed: () => Navigator.pop(context),
                      buttonText: 'Cancel',
                      isNegative: true,
                      height: 44,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ButtonWidget(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => CustomAlertDialogue(
                            context: dialogContext,
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              type == 'admin'
                                  ? addAdminUser(context)
                                  : addClubUser(context);
                              Navigator.pop(context);
                            },
                            title: 'Add User',
                            content: 'Are you sure you want to add this user ${type == 'admin' ? 'as Admin' : 'to this Club'}?',
                            icon: type == 'admin' ? Icons.admin_panel_settings : Icons.group_add,
                          ),
                        );
                      },
                      buttonText: 'Add User',
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
