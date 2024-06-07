import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/controllers/clubs_controller.dart';
import 'package:club_app/widgets/user_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClubInfoPage extends StatelessWidget {
  ClubInfoPage({super.key, required this.clubId});

  final String clubId;

  final clubsController = Get.put(ClubsController());

  final isDescriptionExpanded = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Club Info'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(65),
                child: CachedNetworkImage(
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                    imageUrl: clubsController.clubList
                        .where((club) => club.id == clubId)
                        .first
                        .imageUrl),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: Text(
              clubsController.clubList
                  .where((club) => club.id == clubId)
                  .first
                  .name,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Obx(() {
            return InkWell(
              onTap: () {
                isDescriptionExpanded.value = !isDescriptionExpanded.value;
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Description',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      clubsController.clubList
                          .where((club) => club.id == clubId)
                          .first
                          .description,
                      maxLines: isDescriptionExpanded.value ? 10 : 2,
                      overflow: isDescriptionExpanded.value
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          UserListWidget(type: 'club', clubId: clubId,)
        ],
      ),
    );
  }
}
