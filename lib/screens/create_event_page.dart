import 'dart:io';

import 'package:club_app/controllers/profile_controller.dart';
import 'package:club_app/models/event_model.dart';
import 'package:club_app/utils/repositories/image_repository.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../controllers/clubs_controller.dart';
import '../controllers/event_controller.dart';
import '../controllers/image_picker_controller.dart';
import '../controllers/loading_controller.dart';
import '../widgets/loading_widget.dart';

class CreateEventPage extends StatefulWidget {
  CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final eventController = Get.put(EventController());

  final eventNameController = TextEditingController();

  final eventDescriptionController = TextEditingController();

  final eventDateController = TextEditingController();

  final eventTimeController = TextEditingController();

  final eventLocationController = TextEditingController();

  final imagePickerController = Get.put(ImagePickerController());
  final clubsController = Get.put(ClubsController());
  final profileController = Get.put(ProfileController());
  final loadingController = Get.put(LoadingController());

  var eventDate;
  var organizingClub;
  var bannerUrl;
  bool _isClubDropdownExpanded = false;

  // Custom accent color - yellowish shade
  final Color accentColor = const Color(0xFFF5C518); // Yellow accent color

  Future<void> createEvent(context) async {
    if (imagePickerController.image == null) {
      CustomSnackBar.show(context,
          message: 'Please select a banner image', color: Colors.red);
      return;
    }
    if (eventNameController.text.isEmpty) {
      CustomSnackBar.show(context,
          message: 'Please enter event name', color: Colors.red);
      return;
    }
    if (eventDescriptionController.text.isEmpty) {
      CustomSnackBar.show(context,
          message: 'Please enter event description', color: Colors.red);
      return;
    }
    if (eventLocationController.text.isEmpty) {
      CustomSnackBar.show(context,
          message: 'Please enter event location', color: Colors.red);
      return;
    }
    if (eventDate == null) {
      CustomSnackBar.show(context,
          message: 'Please select event date', color: Colors.red);
      return;
    }
    if (organizingClub == null) {
      CustomSnackBar.show(context,
          message: 'Please select organizing club', color: Colors.red);
      return;
    }
    loadingController.toggleLoading();
    final imageUrl = await ImageRepository()
        .uploadImage(imagePickerController.image!);
    final event = EventModel(
      name: eventNameController.text,
      description: eventDescriptionController.text,
      date: '$eventDate',
      bannerUrl: imageUrl,
      location: eventLocationController.text,
      clubId: organizingClub.id,
      clubName: organizingClub.name,
      clubImageUrl: organizingClub.imageUrl,
      id: '',
    );
    final result = await eventController.createEvent(event);
    imagePickerController.resetImage();
    loadingController.toggleLoading();
    if (result['status'] == 'error') {
      CustomSnackBar.show(context,
          message: result['message'], color: Colors.red);
    } else {
      CustomSnackBar.show(context,
          message: result['message'], color: Colors.green);
    }
    Navigator.pop(context);
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: theme.textTheme.bodyLarge,
            cursorColor: accentColor,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date & Time',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: eventDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 2),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: accentColor,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: accentColor,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (time != null) {
                  setState(() {
                    eventDate = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );
                  });
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: accentColor,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (eventDate != null) ...[
                          Text(
                            DateFormat('EEE, dd MMM').format(eventDate),
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('HH:mm').format(eventDate),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ] else
                          Text(
                            'Select date and time',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: accentColor.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableClubDropdown() {
    final theme = Theme.of(context);
    final isAdmin = profileController.currentUser.value.role == 'admin';
    final clubs = isAdmin
        ? clubsController.clubList
        : (profileController.currentUser.value.clubs ?? []) as List;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Organizing Club',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isClubDropdownExpanded 
                ? accentColor 
                : theme.colorScheme.outline.withOpacity(0.2),
            ),
            boxShadow: _isClubDropdownExpanded
                ? [
                    BoxShadow(
                      color: accentColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header - always visible
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  setState(() {
                    _isClubDropdownExpanded = !_isClubDropdownExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.group,
                        color: accentColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: organizingClub != null
                            ? Row(
                                children: [
                                  if (organizingClub.imageUrl != null && organizingClub.imageUrl.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundImage: NetworkImage(organizingClub.imageUrl),
                                      ),
                                    ),
                                  Text(
                                    organizingClub.name,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ],
                              )
                            : Text(
                                'Select organizing club',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                      ),
                      AnimatedRotation(
                        turns: _isClubDropdownExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: _isClubDropdownExpanded
                              ? accentColor
                              : theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Expandable list
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  height: _isClubDropdownExpanded ? null : 0,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: _isClubDropdownExpanded
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Divider(height: 1, color: accentColor.withOpacity(0.2)),
                            Container(
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.3,
                              ),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: clubs.length,
                                itemBuilder: (context, index) {
                                  final club = clubs[index];
                                  final isSelected = organizingClub?.id == club.id;
                                  
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        organizingClub = club;
                                        _isClubDropdownExpanded = false;
                                      });
                                    },
                                    child: Container(
                                      color: isSelected 
                                          ? accentColor.withOpacity(0.1)
                                          : null,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          if (club.imageUrl != null && club.imageUrl.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(right: 16),
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(club.imageUrl),
                                              ),
                                            )
                                          else
                                            Padding(
                                              padding: const EdgeInsets.only(right: 16),
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: accentColor.withOpacity(0.2),
                                                child: Icon(
                                                  Icons.groups,
                                                  color: accentColor,
                                                ),
                                              ),
                                            ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  club.name,
                                                  style: theme.textTheme.titleMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (isSelected)
                                            Icon(
                                              Icons.check_circle,
                                              color: accentColor,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return PopScope(
      canPop: true,
      onPopInvoked: (bool isPop) {
        eventDate = null;
      },
      child: GestureDetector(
        onTap: () {
          // Close club dropdown when tapping outside
          if (_isClubDropdownExpanded) {
            setState(() {
              _isClubDropdownExpanded = false;
            });
          }
          // Hide keyboard when tapping outside of text fields
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text('Create Event'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonWidget(
                      onPressed: () async {
                        await createEvent(context);
                      },
                      buttonText: 'Create',
                      isColorInverted: true,
                      isNegative: false,
                    ),
                  )
                ],
              ),
              body: Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: InputDecorationTheme(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: accentColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GetBuilder<ImagePickerController>(
                          builder: (logic) {
                            return GestureDetector(
                              onTap: () {
                                imagePickerController.getImage(ImageSource.gallery);
                              },
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.colorScheme.outline.withOpacity(0.2),
                                  ),
                                ),
                                child: imagePickerController.image != null
                                    ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.file(
                                              File(imagePickerController.image!.path),
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            right: 8,
                                            top: 8,
                                            child: IconButton(
                                              onPressed: () {
                                                imagePickerController.resetImage();
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                              style: IconButton.styleFrom(
                                                backgroundColor: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_photo_alternate_outlined,
                                              size: 48,
                                              color: accentColor.withOpacity(0.7),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Add banner image',
                                              style: TextStyle(
                                                color: accentColor.withOpacity(0.9),
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildTextField('Title', eventNameController),
                        const SizedBox(height: 24),
                        _buildDateTimeSection(),
                        const SizedBox(height: 24),
                        _buildTextField('Location', eventLocationController),
                        const SizedBox(height: 24),
                        _buildExpandableClubDropdown(),
                        const SizedBox(height: 24),
                        _buildTextField('About Event', eventDescriptionController, maxLines: 5),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Obx(() {
              return loadingController.isLoading.value ? LoadingWidget() : const SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}
