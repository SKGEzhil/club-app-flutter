import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/controllers/post_controller.dart';
import 'package:club_app/screens/admin_page.dart';
import 'package:club_app/screens/login_page.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../controllers/authentication_controller.dart';
import '../controllers/clubs_controller.dart';
import '../controllers/profile_controller.dart';
import '../models/club_model.dart';
import '../models/post_model.dart';
import 'club_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final clubsController = Get.put(ClubsController());
  final postController = Get.put(PostController());
  final profileController = Get.put(ProfileController());
  final authenticationController = Get.put(AuthenticationController());

  List<Post> get sortedPostList {
    return postController.postList.toList()
      ..sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('The Clubs'),
          backgroundColor: Colors.white,
          actions: [
            Obx(() {
              return Container(
                child:

                profileController.currentUser.value.role == 'admin' ?

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (
                          context) => AdminPage()));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
                          child: Text('Admin',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                    ),
                  ),
                ) :

                SizedBox(),
              );
            }),
            IconButton(
                onPressed: () {
                  authenticationController.logout();
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }, icon: Icon(Icons.logout))
          ],
        ),
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Featured",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)
              ),
            ),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: CarouselSlider(
                    items: sortedPostList.where((post) =>
                    post.imageUrl != '').toList().take(5).map((post) =>
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(imageUrl: post.imageUrl,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,),
                          ),
                        )).toList(),
                    options: CarouselOptions(
                      height: 200,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      // onPageChanged: callbackFunction,
                      scrollDirection: Axis.horizontal,
                    )
                ),
              );
            }),
            Obx(() {
              return Column(
                  children: sortedClubList.map((club) =>
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ClubPage(
                                        clubName: club.name,
                                        clubId: club.id,)));
                            },
                            child: ListTile(
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(25.0),
                                  child: CachedNetworkImage(
                                    imageUrl: club.imageUrl,
                                    width: 47,
                                    height: 47,)
                              ),
                              title: Text(club.name,
                                  style: TextStyle(color: Colors.black)),
                              subtitle: Text(club.description, style: TextStyle(
                                  color: Colors.black.withOpacity(0.5))),
                            ),
                          ),
                          Divider()
                        ],
                      )).toList()
              );
            }),

          ],
        )
    );
  }
}
