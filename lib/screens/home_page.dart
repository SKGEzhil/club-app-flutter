import 'package:club_app/controllers/post_controller.dart';
import 'package:club_app/screens/admin_page.dart';
import 'package:club_app/screens/login_page.dart';
import 'package:club_app/widgets/bottom_nav_bar.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/event_list_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/authentication_controller.dart';
import '../controllers/bottom_nav_controller.dart';
import '../controllers/clubs_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/theme_controller.dart';
import '../models/club_model.dart';
import '../models/post_model.dart';
import '../widgets/carousel_widget.dart';
import '../widgets/club_list_tile.dart';

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
    var clubIdsWithPosts = sortedPosts.map((post) => post.clubId)
        .toSet()
        .toList();

    var clubsWithPosts = clubIdsWithPosts.map((id) =>
        clubsController.clubList.firstWhere((club) => club.id == id)).toList();
    var clubsWithoutPosts = clubsController.clubList.where((
        club) => !clubIdsWithPosts.contains(club.id)).toList();

    return clubsWithPosts + clubsWithoutPosts;
  }

  @override
  Widget build(BuildContext context) {
    final images = sortedPostList
        .where((post) => post.imageUrl != '')
        .toList();

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('The Clubs'),
        // backgroundColor: Colors.white,
        actions: [
          Obx(() {
            return Container(
              child:
              profileController.currentUser.value.role == 'admin' ?
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonWidget(onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (
                        context) => AdminPage()));
                  },
                      buttonText: 'Admin',
                      textColor: Colors.blue,
                      buttonColor: Colors.blue.withOpacity(0.1))
              ) :

              const SizedBox(),
            );
          }),
          IconButton(
              onPressed: () {
                Theme
                    .of(context)
                    .brightness == Brightness.dark
                    ? themeController.changeThemeMode(ThemeMode.light)
                    : themeController.changeThemeMode(ThemeMode.dark);
              },
              icon: Icon(
                  Theme
                      .of(context)
                      .brightness == Brightness.dark
                      ? Icons.light_mode
                      : Icons.dark_mode)
          ),
          IconButton(
              onPressed: () {
                authenticationController.logout();
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }, icon: const Icon(Icons.logout))
        ],
      ),
      body: Obx(() {
        return Stack(
            children: [
              bottomNavController.selectedIndex.value == 0 ?
              EventListWidget() :


              ListView(
                children: [
                  images.isEmpty ? SizedBox() :
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Featured",
                        style: TextStyle(
                          // color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)
                    ),
                  ),
                  images.isEmpty ? SizedBox() :
                  Obx(() {
                    return CarouselWidget(sortedPostList: sortedPostList);
                  }),
                  Obx(() {
                    return Column(
                        children: sortedClubList.map((club) =>
                            Column(
                              children: [
                                ClubListTile(club: club,),
                                const Divider(
                                  thickness: 0,
                                  height: 0,
                                )
                              ],
                            )).toList()
                    );
                  }),

                ],
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: BottomNavBar()
              )
            ]);
      }),
    );
  }
}



