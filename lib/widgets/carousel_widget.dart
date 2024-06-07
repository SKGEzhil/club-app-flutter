import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import 'package:get/get.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({
    super.key,
    required this.sortedPostList,
  });

  final List<Post> sortedPostList;

  @override
  Widget build(BuildContext context) {
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
  }
}
