import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/controllers/post_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../controllers/clubs_controller.dart';
import 'club_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final clubsController = Get.put(ClubsController());
  final postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('The Clubs'),
          backgroundColor: Colors.white,
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
                    items: postController.postList.where((post) =>
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
            Expanded(
              child: Column(
                  children: clubsController.clubList.map((club) =>
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ClubPage(
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
                              subtitle: Text('IIT Bombay', style: TextStyle(
                                  color: Colors.black.withOpacity(0.5))),
                            ),
                          ),
                          Divider()
                        ],
                      )).toList()
              ),
            ),

            // child: Obx(
            //   () => ListView.builder(
            //     itemCount: clubsController.clubList.length,
            //     itemBuilder: (context, index) {
            //       final club = clubsController.clubList[index];
            //       return InkWell(
            //         onTap: () {
            //           Navigator.of(context).push(MaterialPageRoute(builder: (context) => ClubPage(clubName: club.name, clubId: club.id,)));
            //         },
            //         child: ListTile(
            //           leading: ClipRRect(
            //             borderRadius: BorderRadius.circular(25.0),
            //               child: CachedNetworkImage(imageUrl: club.imageUrl, width: 47, height: 47,)),
            //           title: Text(club.name, style: TextStyle(color: Colors.black)),
            //           subtitle: Text('IIT Bombay', style: TextStyle(color: Colors.black.withOpacity(0.5))),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        )
    );
  }
}
