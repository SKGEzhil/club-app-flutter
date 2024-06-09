import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/colors.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/custom_alert_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/clubs_controller.dart';
import '../controllers/post_controller.dart';
import '../controllers/profile_controller.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../screens/image_viewer.dart';

class PostWidget extends StatelessWidget {
  PostWidget({
    super.key,
    required this.post,
  });

  final Post post;

  final isEditMode = false.obs;

  final editPostController = TextEditingController();
  final postController = Get.put(PostController());
  final clubsController = Get.put(ClubsController());

  final profileController = Get.put(ProfileController());
  UserModel get currentUser => profileController.currentUser.value;

  bool get isAuthorized {
      return currentUser.role == 'admin' || clubsController.clubList.where((club) => club.id == post.clubId).first.members.any((member) => member.id == currentUser.id);
  }

  Future<void> updatePost(context) async {
    await postController.updatePost(context, post.id, editPostController.text);
    Navigator.pop(context);
  }

  Future<void> deletePost(context) async {
    await postController.deletePost(context, post.id);
    Navigator.pop(context);
  }

  Offset? _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {

    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;
    // MyColors currentColors = isDarkTheme ? darkColors : lightColors;

    editPostController.text = post.content;

    return InkWell(
      onTapDown: (details) {
        _storePosition(details);
      },
      onLongPress: () async {

        if(!isAuthorized) return;

        final RenderBox overlay =
        Overlay
            .of(context)
            .context
            .findRenderObject() as RenderBox;
        await showMenu(
          context: context,
          elevation: 5,
          // color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          position: RelativeRect.fromLTRB(
            _tapPosition!.dx,
            _tapPosition!.dy,
            overlay.size.width - _tapPosition!.dx,
            overlay.size.height - _tapPosition!.dy,
          ),
          items: <PopupMenuEntry>[
            PopupMenuItem(
              height: 10,
              value: 'Option 1',
              child: Padding(
                padding: EdgeInsets.zero,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: const Row(
                      children: [
                        Text(
                          'Edit Post',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              height: 10,
              value: 'Option 2',
              child: Container(
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                  child: const Row(
                    children: [
                      Text(
                        'Delete Post',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ).then((value) {
          // Handle menu selection if necessary
          if (value != null) {
            if (value == 'Option 1') {
              isEditMode.value = true;
            } else if (value == 'Option 2') {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CustomAlertDialogue(
                      context: context,
                      title: 'Conformation',
                      content:
                      'You are about to delete this post. Do you wish to proceed?',
                      onPressed: () => deletePost(context),
                    );
                  });
              // delete post
            }
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: CachedNetworkImage(
                        imageUrl: 'https://via.placeholder.com/50x50',
                        width: 40.0,
                        height: 40.0)),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    post.imageUrl == ''
                        ? const SizedBox()
                        : InkWell(
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ImageViewer(image: post.imageUrl)));
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: CachedNetworkImage(
                            imageUrl: post.imageUrl,
                            width: 250,
                            fit: BoxFit.cover,
                            height: 250.0,
                          )),
                    ),
                    const SizedBox(height: 8.0),
                    Obx(() {
                      return Padding(
                        padding: const EdgeInsets.only(right: 40.0),
                        child: isEditMode.value
                            ? Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.blue.withOpacity(0.4),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding:
                            const EdgeInsets.only(left: 8, right: 8),
                            child: TextFormField(
                              controller: editPostController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Write something...'),
                              maxLines: null,
                            ),
                          ),
                        )
                            : Text(post.content,
                            style: const TextStyle(
                                // color: Colors.black,
                                fontSize: 16.0)),
                      );
                    }),
                    const SizedBox(height: 8.0),
                    Obx(() {
                      return Container(
                        child: !isEditMode.value
                            ? const SizedBox()
                            : Row(
                          children: [
                            ButtonWidget(
                                onPressed: () {
                                  isEditMode.value = false;
                                },
                                buttonText: 'Cancel',
                                textColor: Colors.red,
                                buttonColor: Colors.red.withOpacity(0.1)),
                            SizedBox(width: 8.0),
                            ButtonWidget(
                                onPressed: () {
                                  // isEditMode.value = false;

                                  // show custom alert dialog
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialogue(
                                          context: context,
                                          title: 'Conformation',
                                          content:
                                          'You are about to save the changes made to this post. Do you wish to proceed?',
                                          onPressed: () =>
                                              updatePost(context),
                                        );
                                      });

                                  // post.content = editPostController.text;
                                },
                                buttonText: 'Done',
                                textColor: Colors.blue,
                                buttonColor:
                                Colors.blue.withOpacity(0.1)),
                          ],
                        ),
                      );
                    }),
                    Row(
                      children: [
                        Expanded(
                          child: Text(post.formattedDateTime,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: currentColors.tertiaryTextColor
                              )),
                        ),

                        Obx(() {
                          return Container(
                            child:
                            isEditMode.value
                                ? const SizedBox()
                                : isAuthorized ?
                            InkWell(
                              onTap: () {
                                isEditMode.value = true;
                              },
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: currentColors.oppositeColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(width: 4.0),
                                      Icon(
                                          size: 12.0,
                                          color: currentColors.oppositeColor.withOpacity(0.5),
                                          Icons.edit_outlined),
                                      const SizedBox(width: 3.0),
                                      Text('Edit',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color:
                                              currentColors.tertiaryTextColor)),
                                      SizedBox(width: 4.0),
                                    ],
                                  ),
                                ),
                              ),
                            ) :
                            const SizedBox(),
                          );
                        }),
                        const SizedBox(width: 8.0),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
