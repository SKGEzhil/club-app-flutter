import 'package:club_app/screens/create_feedback_page.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/colors.dart';
import '../../controllers/bottom_nav_controller.dart';
import '../../controllers/clubs_controller.dart';
import '../../controllers/event_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../screens/create_event_page.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  final bottomNavController = Get.put(BottomNavController());
  final eventController = Get.put(EventController());
  final clubsController = Get.put(ClubsController());
  final profileController = Get.put(ProfileController());

  var selectedEvent = ''.obs;
  var selectedClub = ''.obs;


  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme
        .of(context)
        .brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 12),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Obx(() {
                return Container(
                  child: bottomNavController.isSheetOpen.value
                      ? bottomNavController.isFeedbackSelectionVisible.value
                      ? Container(
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .brightness ==
                            Brightness.dark
                            ? Color.fromRGBO(18, 18, 18, 1.0)
                            : Theme
                            .of(context)
                            .scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        border: Border.all(
                            width: 1,
                            color: Theme
                                .of(context)
                                .primaryColor)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Select a Club',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(() {
                              final isAdmin = profileController.currentUser.value.role == 'admin';
                              final clubs = isAdmin 
                                  ? clubsController.clubList
                                  : (profileController.currentUser.value.clubs ?? []) as List;
                              
                              return DropdownMenu<String>(
                                  onSelected: (String? value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedClub.value = value;
                                      });
                                    }
                                  },
                                  inputDecorationTheme:
                                  InputDecorationTheme(
                                    fillColor: Theme
                                        .of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                    constraints: BoxConstraints(
                                      minWidth: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                  ),
                                  dropdownMenuEntries: (clubs as List)
                                      .map((club) => DropdownMenuEntry<String>(
                                        value: club.id,
                                        label: club.name,
                                      ))
                                      .toList());
                            }),
                          ),
                          Row(
                            children: [
                              Text(
                                'Select an Event',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(() {
                              return DropdownMenu(
                                  onSelected: (value) {
                                    setState(() {
                                      selectedEvent.value =
                                          eventController.eventList
                                              .firstWhere((event) =>
                                          event.id == value)
                                              .id;
                                    });
                                  },
                                  inputDecorationTheme:
                                  InputDecorationTheme(
                                    fillColor: Theme
                                        .of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                    constraints: BoxConstraints(
                                      minWidth: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                  ),
                                  dropdownMenuEntries:
                                  selectedClub.value == ''
                                      ? []
                                      : eventController.eventList
                                      .where((event) =>
                                  event.clubId ==
                                      selectedClub.value)
                                      .map((club) {
                                    return DropdownMenuEntry(
                                        value: club.id,
                                        label: club.name);
                                  }).toList());
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: ButtonWidget(
                                  onPressed: () =>
                                  {
                                    selectedClub.value == '' ||
                                        selectedEvent.value == ''
                                        ? CustomSnackBar.show(context,
                                        message:
                                        'Please fill all the required fields',
                                        color: Colors.red)
                                        : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateFeedbackPage(
                                              clubId: selectedClub
                                                  .value,
                                              eventId: selectedEvent
                                                  .value,
                                            ),
                                      ),
                                    )
                                  },
                                  buttonText: 'Create Feedback Form',
                                  isNegative: false),
                            ),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .brightness ==
                            Brightness.dark
                            ? Color.fromRGBO(18, 18, 18, 1.0)
                            : Theme
                            .of(context)
                            .scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        border: Border.all(
                            width: 1,
                            color: Theme
                                .of(context)
                                .primaryColor)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: currentColors.oppositeColor
                                  .withOpacity(0.4),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Create Event',
                            style: TextStyle(),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateEventPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text(
                            'Create Feedback Form',
                            style: TextStyle(),
                          ),
                          onTap: () {
                            bottomNavController.isFeedbackSelectionVisible.value = true;
                            },
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  )
                      : SizedBox(
                    height: 40,
                  ),
                );
              }),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: GetBuilder<BottomNavController>(builder: (logic) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 18, 8, 8),
                  child: Obx(() {
                    // Check if user is admin or has any clubs
                    bool showAddButton = profileController.currentUser.value.role == 'admin' ||
                        (profileController.currentUser.value.clubs != null && 
                         profileController.currentUser.value.clubs!.isNotEmpty);

                    return Row(
                      mainAxisAlignment: showAddButton ? MainAxisAlignment.spaceAround : MainAxisAlignment.spaceEvenly,
                      children: [
                        bottonNavItems(currentColors, Icons.home, 0),
                        bottonNavItems(currentColors, Icons.group, 1),
                        if (showAddButton)
                          InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            onTap: () {
                              bottomNavController.isSheetOpen.value =
                              !bottomNavController.isSheetOpen.value;
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(Icons.add,
                                    size: 30, color: Colors.white),
                              ),
                            ),
                          ),
                        bottonNavItems(currentColors, Icons.feedback_outlined, 2),
                        bottonNavItems(currentColors, Icons.person, 3),
                      ],
                    );
                  }),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  InkWell bottonNavItems(ThemeColors currentColors, IconData icon, int index) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        bottomNavController.selectIndex(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 30, color: Colors.black.withOpacity(0.7)),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: bottomNavController.selectedIndex.value == index
                    ? Colors.red
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          )
          // Text('Events',
          //   style: TextStyle(
          //     color: currentColors.oppositeColor
          //   ),
          // )
        ],
      ),
    );
  }
}
