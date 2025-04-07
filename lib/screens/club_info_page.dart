import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/controllers/clubs_controller.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/dialogue_widgets/edit_club_dialogue.dart';
import 'package:club_app/widgets/app_widgets/user_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkfy_text/linkfy_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/image_picker_controller.dart';
import '../controllers/loading_controller.dart';
import '../controllers/profile_controller.dart';
import '../models/user_model.dart';
import '../widgets/dialogue_widgets/custom_alert_dialogue.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/loading_widget.dart';

class ClubInfoPage extends StatelessWidget {
  ClubInfoPage({super.key, required this.clubId});

  final String clubId;

  final clubsController = Get.put(ClubsController());
  final imagePickerController = Get.put(ImagePickerController());
  final profileController = Get.put(ProfileController());
  final loadingController = Get.put(LoadingController());

  // Custom accent color - yellowish shade
  static const Color accentColor = Color(0xFFF5C518);

  UserModel get currentUser => profileController.currentUser.value;

  bool get isAuthorized {
    return currentUser.role == 'admin' ||
        clubsController.clubList
            .where((club) => club.id == clubId)
            .first
            .members
            .any((member) => member.id == currentUser.id);
  }

  final isDescriptionExpanded = false.obs;

  void showEditClubDialogue(context) {
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: 'Edit Club Info',
        context: context,
        pageBuilder: (context, _, __) => PopScope(
            onPopInvoked: (bool didPop) {
              if (didPop) {
                imagePickerController.resetImage();
              }
            },
            child: EditClubDialogue(
              clubId: clubId,
            )));
  }

  Future<void> deleteClub(context) async {
    final result = await clubsController.deleteClub(clubId);
    result['status'] == 'error'
        ? CustomSnackBar.show(context,
            message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
            message: result['message'], color: Colors.green);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (isAuthorized)
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onPressed: () => showEditClubDialogue(context),
                ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image Section
                Obx(() {
                  var club = clubsController.clubList.where((club) => club.id == clubId);
                  if(club.isEmpty) {
                    return const SizedBox();
                  }
                  return Stack(
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark ? theme.colorScheme.surface : accentColor.withOpacity(0.1),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: clubsController.clubList
                              .where((club) => club.id == clubId)
                              .first
                              .imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                theme.colorScheme.surface,
                                theme.colorScheme.surface.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),

                // Club Info Section
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Club Name
                      GetBuilder<ClubsController>(builder: (logic) {
                        var club = clubsController.clubList.where((club) => club.id == clubId);
                        if(club.isEmpty) {
                          return const SizedBox();
                        }
                        return Text(
                          clubsController.clubList
                              .where((club) => club.id == clubId)
                              .first
                              .name,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        );
                      }),

                      const SizedBox(height: 24),

                      // About Section
                      Text(
                        'About',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        var club = clubsController.clubList.where((club) => club.id == clubId);
                        if(club.isEmpty) {
                          return const SizedBox();
                        }
                        return InkWell(
                          onTap: () {
                            isDescriptionExpanded.value = !isDescriptionExpanded.value;
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
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
                            child: LinkifyText(
                              clubsController.clubList
                                  .where((club) => club.id == clubId)
                                  .first
                                  .description,
                              maxLines: isDescriptionExpanded.value ? 10 : 2,
                              overflow: isDescriptionExpanded.value
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                              onTap: (link) async {
                                if (link.type == LinkType.url) {
                                  final Uri url = Uri.parse('${link.value}');
                                  if (!await launchUrl(url)) {
                                    CustomSnackBar.show(context,
                                        message: 'Could not launch ${link.value}',
                                        color: Colors.red);
                                    throw Exception('Could not launch ${link.value}');
                                  }
                                }
                                if (link.type == LinkType.email) {
                                  final Uri url = Uri.parse('mailto:${link.value}');
                                  if (!await launchUrl(url)) {
                                    CustomSnackBar.show(context,
                                        message: 'Could not launch ${link.value}',
                                        color: Colors.red);
                                    throw Exception('Could not launch ${link.value}');
                                  }
                                }
                              },
                              linkStyle: TextStyle(color: accentColor),
                              linkTypes: [
                                LinkType.url,
                                LinkType.userTag,
                                LinkType.hashTag,
                                LinkType.email
                              ],
                              textStyle: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.8),
                                height: 1.5,
                              ),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 24),

                      // Members Section
                      UserListWidget(
                        type: 'club',
                        clubId: clubId,
                      ),

                      // Delete Button (for admins only)
                      if (isAuthorized) ...[
                        const SizedBox(height: 24),
                        Center(
                          child: ButtonWidget(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (dialogueContext) {
                                  return CustomAlertDialogue(
                                    context: dialogueContext,
                                    onPressed: () => deleteClub(context),
                                    title: 'Delete Club',
                                    content:
                                        'Are you sure you want to delete this club? This action cannot be undone.',
                                  );
                                },
                              );
                            },
                            buttonText: 'Delete Club',
                            isNegative: true,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(() {
          return loadingController.isLoading.value ? LoadingWidget() : const SizedBox();
        }),
      ],
    );
  }
}
