import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/controllers/clubs_controller.dart';
import 'package:club_app/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controllers/image_picker_controller.dart';
import '../controllers/post_controller.dart';
import '../controllers/profile_controller.dart';
import 'package:intl/intl.dart';

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
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: Colors.white,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://via.placeholder.com/50x50',
                                                width: 40.0,
                                                height: 40.0)),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            post.imageUrl == ''
                                                ? const SizedBox()
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl: post.imageUrl,
                                                      width: 250,
                                                      fit: BoxFit.cover,
                                                      height: 250.0,
                                                    )),
                                            const SizedBox(height: 8.0),
                                            Text(post.content,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.0)),
                                            const SizedBox(height: 8.0),
                                            Text(post.formattedDateTime,
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.black
                                                        .withOpacity(0.5))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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

                // clubsController.clubList.value.any((club) => club.members.any((member) => member.id == profileController.currentUser.value.id))

                ? Column(
                    children: [
                      GetBuilder<ImagePickerController>(builder: (logic) {
                        return Container(
                          child: imagePickerController.image == null
                              ? SizedBox(
                                  width: 0,
                                )
                              : Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.file(
                                          File(imagePickerController.image!
                                              .path), // Placeholder image URL
                                          fit: BoxFit.cover,
                                          // Ensure the image fits within the space
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0.0,
                                      child: GestureDetector(
                                        onTap: () {
                                          imagePickerController.resetImage();
                                        },
                                        child: const Align(
                                          alignment: Alignment.topRight,
                                          child: CircleAvatar(
                                            radius: 10.0,
                                            backgroundColor: Colors.black,
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 15.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                        );
                      }),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.05),
                                // borderRadius: BorderRadius.circular(25),
                              ),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          imagePickerController
                                              .getImage(ImageSource.gallery);
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: TextFormField(
                                              maxLines: 5,
                                              minLines: 1,
                                              // expands: true,
                                              controller: contentText,
                                              cursorColor: Colors.deepOrange,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                hintText: 'Write Something',
                                                focusColor: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: createPost,
                                        icon: const Icon(
                                          Icons.send,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : const SizedBox()
          ],
        );
      }),
    );
  }
}
