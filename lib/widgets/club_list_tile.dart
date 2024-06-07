import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/club_model.dart';
import '../screens/club_page.dart';

class ClubListTile extends StatelessWidget {
  const ClubListTile({
    super.key, required this.club,
  });

  final Club club;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ClubPage(
                  clubName: club.name,
                  clubId: club.id,)));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
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
          subtitle: Text(
              club.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
              color: Colors.black.withOpacity(0.5))),
        ),
      ),
    );
  }
}