import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/image_picker_controller.dart';
import '../controllers/post_controller.dart';
import '../controllers/profile_controller.dart';


class BottomMessageBar extends StatelessWidget {
  BottomMessageBar({super.key, required this.clubId});

  final String clubId;

  final imagePickerController = Get.put(ImagePickerController());
  final postController = Get.put(PostController());
  final profileController = Get.find<ProfileController>();

  final contentText = TextEditingController();

  Future<void> createPost(context) async {
    await postController.createPost(context,
        contentText.text, profileController.currentUser.value.id, clubId);
    contentText.text = '';
    imagePickerController.resetImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color.fromRGBO(255, 255, 255, 1),
            Color.fromRGBO(255, 255, 255, 1),
            Color.fromRGBO(255, 255, 255, 1),
            Color.fromRGBO(255, 255, 255, 1),
            Color.fromRGBO(255, 255, 255, 1),
            Color.fromRGBO(255, 255, 255, 1),
            Color.fromRGBO(255, 255, 255, 0.0),
          ],
        ),
        // borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            GetBuilder<ImagePickerController>(builder: (logic) {
              return Container(
                color: Colors.transparent,
                child: imagePickerController.image == null
                    ? SizedBox(
                  width: 0,
                )
                    : Align(
                  alignment: Alignment.centerLeft,
                      child: Stack(
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
                    ),
              );
            }),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.transparent,
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
                                  Colors.blue.withOpacity(0.1),
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
                              onPressed: () => createPost(context),
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
        ),
      ),
    );
  }
}
