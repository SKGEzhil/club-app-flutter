import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/controllers/clubs_controller.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/edit_club_dialogue.dart';
import 'package:club_app/widgets/user_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/image_picker_controller.dart';
import '../controllers/profile_controller.dart';
import '../models/user_model.dart';

class ClubInfoPage extends StatelessWidget {
  ClubInfoPage({super.key, required this.clubId});

  final String clubId;

  final clubsController = Get.put(ClubsController());
  final imagePickerController = Get.put(ImagePickerController());
  final profileController = Get.put(ProfileController());

  UserModel get currentUser => profileController.currentUser.value;

  bool get isAuthorized {
    print("current user: ${currentUser.role}");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Club Info'),
        actions: [
          !isAuthorized
              ? const SizedBox()
              :
          ButtonWidget(
              onPressed: () => showEditClubDialogue(context),
              buttonText: 'Edit info',
              preceedingIcon: Icons.edit,
              textColor: Colors.blue,
              buttonColor: Colors.blue.withOpacity(0.1))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(65),
                child: Obx(() {
                  return CachedNetworkImage(
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                      imageUrl: clubsController.clubList
                          .where((club) => club.id == clubId)
                          .first
                          .imageUrl);
                }),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: GetBuilder<ClubsController>(builder: (logic) {
              return Text(
                clubsController.clubList
                    .where((club) => club.id == clubId)
                    .first
                    .name,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Obx(() {
            return InkWell(
              onTap: () {
                isDescriptionExpanded.value = !isDescriptionExpanded.value;
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GetBuilder<ClubsController>(builder: (logic) {
                      return Text(
                        'Description',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                    Text(
                      clubsController.clubList
                          .where((club) => club.id == clubId)
                          .first
                          .description,
                      maxLines: isDescriptionExpanded.value ? 10 : 2,
                      overflow: isDescriptionExpanded.value
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          UserListWidget(
            type: 'club',
            clubId: clubId,
          )
        ],
      ),
    );
  }
}
