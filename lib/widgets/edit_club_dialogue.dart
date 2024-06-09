import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/widgets/custom_alert_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/clubs_controller.dart';
import '../controllers/image_picker_controller.dart';
import '../models/club_model.dart';
import '../utils/server_utils.dart';
import 'button_widget.dart';

class EditClubDialogue extends StatefulWidget {
  EditClubDialogue({super.key, required this.clubId});

  final String clubId;

  @override
  State<EditClubDialogue> createState() => _EditClubDialogueState();
}

class _EditClubDialogueState extends State<EditClubDialogue> {

  @override
  void initState() {
    super.initState();
    clubNameController.text = club.name;
    clubDescriptionController.text = club.description;
  }

  final clubNameController = TextEditingController();

  final clubDescriptionController = TextEditingController();

  final imagePickerController = Get.put(ImagePickerController());

  Club get club =>
      clubsController.clubList.where((club) => club.id == widget.clubId).first;

  final clubsController = Get.put(ClubsController());

  void updateClubInfo(context) async {
    var imageUrl = club.imageUrl;

    if (imagePickerController.image != null) {
      imageUrl = await ServerUtils.uploadImage(imagePickerController.image!);
    }

    print('Club Name: ${clubNameController.text}');
    print('Club Description: ${clubDescriptionController.text}');
    print('Club Image: $imageUrl');
    print('Club ID: ${widget.clubId}');

    clubsController.updateClub(context, widget.clubId, clubNameController.text,
        clubDescriptionController.text, imageUrl);

    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // clubNameController.text = club.name;
    // clubDescriptionController.text = club.description;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Edit Club Info",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        GetBuilder<ImagePickerController>(builder: (logic) {
                          return Container(
                            child: imagePickerController.image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(65),
                                    child: Image.file(
                                      File(imagePickerController.image!.path),
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(65),
                                    child: CachedNetworkImage(
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                      imageUrl: club.imageUrl,
                                    ),
                                  ),
                          );
                        }),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: () {
                              imagePickerController
                                  .getImage(ImageSource.gallery);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Icon(
                                      size: 18,
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Club Name :',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_outlined),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.blue.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
                            child: TextFormField(
                              // initialValue: club.name,
                              controller: clubNameController,
                              onChanged: (value) {
                                clubNameController.text = value;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                // hintText: '${club.name}',
                              ),
                              style: const TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Description :',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_outlined),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.blue.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
                            child: TextFormField(
                              controller: clubDescriptionController,
                              onChanged: (value) {
                                clubDescriptionController.text = value;
                              },
                              // initialValue: club.description,
                              maxLines: 4,
                              minLines: 1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                // hintText: '${club.name}',
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonWidget(
                      onPressed: () => {
                        // updateClubInfo(context),
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialogue(
                                      context: context,
                                      onPressed: () => updateClubInfo(context),
                                      title: 'Conformation',
                                      content:
                                          'Are you sure you want to update the club info?');
                                })
                          },
                      buttonText: 'Update Club Info',
                      textColor: Colors.blue,
                      buttonColor: Colors.blue.withOpacity(0.1))
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}