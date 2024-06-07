import 'package:club_app/controllers/clubs_controller.dart';
import 'package:club_app/widgets/bottom_message_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/image_picker_controller.dart';
import '../controllers/post_controller.dart';
import '../controllers/profile_controller.dart';

import '../widgets/post_widget.dart';

class ClubPage extends StatelessWidget {
  ClubPage({super.key, required this.clubName, required this.clubId});

  final postController = Get.put(PostController());
  final clubsController = Get.put(ClubsController());
  final profileController = Get.put(ProfileController());
  final imagePickerController = Get.put(ImagePickerController());

  final String clubName;
  final String clubId;

  final contentText = TextEditingController();

  Future<void> createPost() async {
    await postController.createPost(
        contentText.text, profileController.currentUser.value.id, clubId);
    contentText.text = '';
    imagePickerController.resetImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(clubName),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  children: postController.postList
                      .where((post) => post.clubId == clubId)
                      .toList()
                      .map((post) => Column(
                            children: [
                              const Divider(),
                              PostWidget(post: post),
                            ],
                          ))
                      .toList(),
                ),
              ),
            ),

            clubsController.clubList
                    .where((club) => club.id == clubId)
                    .first
                    .members
                    .any((member) =>
                        member.id == profileController.currentUser.value.id)
                ? BottomMessageBar(clubId: clubId)
                : const SizedBox()
          ],
        );
      }),
    );
  }
}

