import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/utils/repositories/image_repository.dart';
import 'package:club_app/widgets/dialogue_widgets/custom_alert_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/clubs_controller.dart';
import '../../controllers/image_picker_controller.dart';
import '../../controllers/loading_controller.dart';
import '../../models/club_model.dart';
import '../button_widget.dart';
import '../custom_snackbar.dart';

class EditClubDialogue extends StatefulWidget {
  EditClubDialogue({super.key, required this.clubId});

  final String clubId;

  @override
  State<EditClubDialogue> createState() => _EditClubDialogueState();
}

class _EditClubDialogueState extends State<EditClubDialogue> {
  final clubNameController = TextEditingController();
  final clubDescriptionController = TextEditingController();
  final imagePickerController = Get.put(ImagePickerController());
  final loadingController = Get.put(LoadingController());
  final clubsController = Get.put(ClubsController());

  // Custom accent color - yellowish shade
  static const Color accentColor = Color(0xFFF5C518);

  Club get club =>
      clubsController.clubList.where((club) => club.id == widget.clubId).first;

  @override
  void initState() {
    super.initState();
    clubNameController.text = club.name;
    clubDescriptionController.text = club.description;
  }

  void updateClubInfo(context) async {
    var imageUrl = club.imageUrl;
    loadingController.toggleLoading();
    
    if (imagePickerController.image != null) {
      imageUrl = await ImageRepository().uploadImage(imagePickerController.image!);
      imagePickerController.resetImage();
    }

    final result = await clubsController.updateClub(
      context,
      widget.clubId,
      clubNameController.text,
      clubDescriptionController.text,
      imageUrl,
    );
    loadingController.toggleLoading();

    result['status'] == 'error'
        ? CustomSnackBar.show(context,
            message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
            message: result['message'], color: Colors.green);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int? maxLines,
    TextStyle? style,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines ?? 1,
            style: style ?? theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              prefixIcon: Icon(
                Icons.edit_outlined,
                color: accentColor.withOpacity(0.5),
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 500,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  "Edit Club Info",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Club Image
                Center(
                  child: Stack(
                    children: [
                      GetBuilder<ImagePickerController>(
                        builder: (logic) {
                          return Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: accentColor.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(65),
                              child: imagePickerController.image != null
                                  ? Image.file(
                                      File(imagePickerController.image!.path),
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    )
                                  : CachedNetworkImage(
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                      imageUrl: club.imageUrl,
                                    ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          onTap: () {
                            imagePickerController.getImage(ImageSource.gallery);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Club Name Field
                _buildTextField(
                  controller: clubNameController,
                  label: 'Club Name',
                  hint: 'Enter club name',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Description Field
                _buildTextField(
                  controller: clubDescriptionController,
                  label: 'Description',
                  hint: 'Enter club description',
                  maxLines: 4,
                ),
                const SizedBox(height: 32),

                // Update Button
                ButtonWidget(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => CustomAlertDialogue(
                        context: dialogContext,
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          updateClubInfo(context);
                          Navigator.pop(context);
                        },
                        title: 'Update Club',
                        content: 'Are you sure you want to update the club info?',
                        icon: Icons.edit_note,
                      ),
                    );
                  },
                  buttonText: 'Update Club Info',
                  isNegative: false,
                  height: 48,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
