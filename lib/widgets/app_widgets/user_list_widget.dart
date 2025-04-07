import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/models/user_model.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/dialogue_widgets/custom_alert_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/colors.dart';
import '../../controllers/admin_controller.dart';
import '../../controllers/clubs_controller.dart';
import '../../controllers/loading_controller.dart';
import '../../controllers/profile_controller.dart';
import '../dialogue_widgets/add_user_dialogue.dart';
import '../custom_snackbar.dart';

class UserListWidget extends StatelessWidget {
  UserListWidget({
    super.key,
    required this.type,
    this.clubId,
  });

  final adminController = Get.put(AdminController());
  final clubsController = Get.put(ClubsController());
  final profileController = Get.put(ProfileController());
  final loadingController = Get.put(LoadingController());

  // Custom accent color - yellowish shade
  static const Color accentColor = Color(0xFFF5C518);

  UserModel get currentUser => profileController.currentUser.value;

  bool get isAuthorized {
    if (clubId != null) {
      return currentUser.role == 'admin' ||
          clubsController.clubList
              .where((club) => club.id == clubId)
              .first
              .members
              .any((member) => member.id == currentUser.id);
    } else {
      return currentUser.role == 'admin';
    }
  }

  final clubId;
  final String type;

  Future<void> removeAdminUser(context, index) async {
    loadingController.toggleLoading();
    final result = await adminController.updateUserRole(
        context, adminController.adminUsers[index].email, "user");
    loadingController.toggleLoading();
    result['status'] == 'error'
        ? CustomSnackBar.show(context,
            message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
            message: result['message'], color: Colors.green);
  }

  Future<void> removeClubUser(context, index) async {
    loadingController.toggleLoading();
    final result = await clubsController.removeUserFromClub(
        context,
        clubId,
        clubsController.clubList
            .where((club) => club.id == clubId)
            .first
            .members[index]
            .email);
    loadingController.toggleLoading();
    result['status'] == 'error'
        ? CustomSnackBar.show(context,
            message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
            message: result['message'], color: Colors.green);
  }

  void showAddUserDialogue(context) {
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: type == 'admin' ? 'Add Admin User' : 'Add Club User',
        context: context,
        pageBuilder: (context, _, __) => AddUserDialogue(
              type: type,
              clubId: clubId,
            ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      if (type != 'admin') {
        var club = clubsController.clubList.where((club) => club.id == clubId);
        if (club.isEmpty) {
          return const SizedBox();
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  type == 'admin' ? 'Admin Users' : 'Club Members',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (isAuthorized)
                  IconButton(
                    onPressed: () => showAddUserDialogue(context),
                    icon: Icon(
                      Icons.person_add_rounded,
                      color: accentColor,
                    ),
                    tooltip: type == 'admin' ? 'Add Admin' : 'Add Member',
                  ),
              ],
            ),
          ),

          // Users List
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              itemCount: type == 'admin'
                  ? adminController.adminUsers.length
                  : clubsController.clubList
                      .where((club) => club.id == clubId)
                      .first
                      .members
                      .length,
              itemBuilder: (context, index) {
                final user = type == 'admin'
                    ? adminController.adminUsers[index]
                    : clubsController.clubList
                        .where((club) => club.id == clubId)
                        .first
                        .members[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          imageUrl: user.photoUrl,
                          placeholder: (context, url) => Container(
                            width: 48,
                            height: 48,
                            color: accentColor.withOpacity(0.1),
                            child: Icon(
                              Icons.person,
                              color: accentColor.withOpacity(0.5),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 48,
                            height: 48,
                            color: accentColor.withOpacity(0.1),
                            child: Icon(
                              Icons.error_outline,
                              color: accentColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        user.email,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      trailing: isAuthorized
                          ? IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogueContext) {
                                    return CustomAlertDialogue(
                                      context: dialogueContext,
                                      onPressed: () {
                                        Navigator.pop(dialogueContext);
                                        type == 'admin'
                                            ? removeAdminUser(context, index)
                                            : removeClubUser(context, index);
                                      },
                                      title: 'Remove User',
                                      content:
                                          'Are you sure you want to remove ${user.name} from ${type == 'admin' ? 'Admin' : 'the Club'}?',
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red.withOpacity(0.8),
                              ),
                              tooltip: 'Remove User',
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
