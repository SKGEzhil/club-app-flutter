import 'dart:async';
import 'dart:ui';

import 'package:club_app/controllers/post_controller.dart';
import 'package:club_app/screens/admin_page.dart';
import 'package:club_app/screens/calendarPage.dart';
import 'package:club_app/screens/club_list_page.dart';
import 'package:club_app/screens/login_page.dart';
import 'package:club_app/screens/profile_page.dart';
import 'package:club_app/screens/secret_info_page.dart';
import 'package:club_app/widgets/app_widgets/bottom_nav_bar.dart';
import 'package:club_app/widgets/app_widgets/feedback_list_widget.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/app_widgets/event_list_widget.dart';
import 'package:club_app/widgets/dialogue_widgets/custom_alert_dialogue.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../controllers/authentication_controller.dart';
import '../controllers/bottom_nav_controller.dart';
import '../controllers/clubs_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/theme_controller.dart';
import '../models/club_model.dart';
import '../models/post_model.dart';
import '../widgets/app_widgets/carousel_widget.dart';
import '../widgets/app_widgets/club_list_tile.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final clubsController = Get.put(ClubsController());
  final postController = Get.put(PostController());
  final profileController = Get.put(ProfileController());
  final authenticationController = Get.put(AuthenticationController());
  final themeController = Get.put(ThemeController());
  final bottomNavController = Get.put(BottomNavController());

  List<Post> get sortedPostList {
    final sortedList = postController.postList.toList()
      ..sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    return sortedList;
  }

  List<Club> get sortedClubList {
    var sortedPosts = sortedPostList;
    var clubIdsWithPosts =
        sortedPosts.map((post) => post.clubId).toSet().toList();

    var clubsWithPosts = clubIdsWithPosts
        .map((id) =>
            clubsController.clubList.firstWhere((club) => club.id == id))
        .toList();
    var clubsWithoutPosts = clubsController.clubList
        .where((club) => !clubIdsWithPosts.contains(club.id))
        .toList();

    return clubsWithPosts + clubsWithoutPosts;
  }

  @override
  Widget build(BuildContext context) {
    final images = sortedPostList.where((post) => post.imageUrl != '').toList();

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Obx(() {
        return Stack(children: [
          Container(
            child: bottomNavController.selectedIndex.value == 0
                ? EventListWidget()
                : bottomNavController.selectedIndex.value == 1
                    ? ClubListPage()
                    : bottomNavController.selectedIndex.value == 2
                        ? FeedbackListWidget()
                        : ProfilePage(),
          ),
          bottomNavController.isSheetOpen.value ?
          ScreenOverlay() : SizedBox(),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BackdropFilter(
                    filter: bottomNavController.isSheetOpen.value ?
                    ImageFilter.blur(sigmaX: 10, sigmaY: 10) : ImageFilter.blur(),
                child: BottomNavBar()),
              ))
        ]);
      }),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return AppBar(
      title: Obx(() {
        return GestureDetector(
          onTap: Info().handleTap,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(bottomNavController.selectedIndex.value == 0
                    ? 'Events'
                    : bottomNavController.selectedIndex.value == 1
                    ? 'Clubs'
                    : bottomNavController.selectedIndex.value == 2
                    ? 'Feedback'
                    : 'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
                ),
                Text(bottomNavController.selectedIndex.value == 0
                    ? 'Current & Upcoming Events'
                    : bottomNavController.selectedIndex.value == 1
                    ? 'All Available Clubs'
                    : bottomNavController.selectedIndex.value == 2
                    ? 'Provide your Feedback'
                    : 'Settings & Profile',
                  style: TextStyle(
                    fontSize: 15,
                    color: currentColors.oppositeColor.withOpacity(0.6),
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      // backgroundColor: Colors.white,
    );
  }


// AppBar buildAppBar(BuildContext context) {
  //   return AppBar(
  //     title: Obx(() {
  //       return GestureDetector(
  //         onTap: Info().handleTap,
  //         child: Text(bottomNavController.selectedIndex.value == 0
  //             ? 'Events'
  //             : bottomNavController.selectedIndex.value == 1
  //                 ? 'Clubs'
  //                 : 'Feedback'),
  //       );
  //     }),
  //     // backgroundColor: Colors.white,
  //     actions: [
  //       Obx(() {
  //         return Container(
  //           child: profileController.currentUser.value.role == 'admin'
  //               ? Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: ButtonWidget(
  //                       onPressed: () {
  //                         Navigator.of(context).push(MaterialPageRoute(
  //                             builder: (context) => AdminPage()));
  //                       },
  //                       buttonText: 'Admin',
  //                       isColorInverted: true,
  //                       isNegative: false))
  //               : const SizedBox(),
  //         );
  //       }),
  //       IconButton(
  //           onPressed: () {
  //             Theme.of(context).brightness == Brightness.dark
  //                 ? themeController.changeThemeMode(ThemeMode.light)
  //                 : themeController.changeThemeMode(ThemeMode.dark);
  //           },
  //           icon: Icon(Theme.of(context).brightness == Brightness.dark
  //               ? Icons.light_mode
  //               : Icons.dark_mode)),
  //       IconButton(
  //           onPressed: () {
  //             showDialog(
  //                 context: context,
  //                 builder: (dialogueContext) {
  //                   return CustomAlertDialogue(
  //                       context: dialogueContext,
  //                       onPressed: () {
  //                         Navigator.pop(dialogueContext);
  //                         authenticationController.logout();
  //                         Navigator.pop(context);
  //                         Navigator.of(context)
  //                             .push(MaterialPageRoute(builder: (context) => LoginPage()));
  //                       },
  //                       title: 'Confirm Logout',
  //                       content: 'Are u sure do u want to logout?');
  //                 });
  //
  //           },
  //           icon: const Icon(Icons.logout))
  //     ],
  //   );
  // }
}

class ScreenOverlay extends StatelessWidget {
  ScreenOverlay({super.key});

  final bottomNavController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // WidgetsBinding.instance.addPostFrameCallback((_) {
          bottomNavController.isSheetOpen.value = false;
          bottomNavController.isFeedbackSelectionVisible.value = false;
        // });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0)
        ),
      ),
    );
  }
}

