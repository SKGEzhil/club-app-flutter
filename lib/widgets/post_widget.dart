import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../screens/image_viewer.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: CachedNetworkImage(
                      imageUrl: 'https://via.placeholder.com/50x50',
                      width: 40.0,
                      height: 40.0)),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  post.imageUrl == ''
                      ? const SizedBox()
                      : InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ImageViewer(image: post.imageUrl)));
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: CachedNetworkImage(
                                imageUrl: post.imageUrl,
                                width: 250,
                                fit: BoxFit.cover,
                                height: 250.0,
                              )),
                        ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0),
                    child: Text(post.content,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 16.0)),
                  ),
                  const SizedBox(height: 8.0),
                  Text(post.formattedDateTime,
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black.withOpacity(0.5))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
