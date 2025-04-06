import 'package:club_app/controllers/clubs_controller.dart';
import 'package:club_app/widgets/app_widgets/club_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/colors.dart';

class ClubListPage extends StatelessWidget {
  ClubListPage({super.key});

  final clubsController = Get.put(ClubsController());

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return ListView(
      children: [
        Obx(() {
          return Column(
            children: [
              ...clubsController.clubList.map((club) => Column(
                children: [
                  ClubListTile(club: club),
                  const Divider(height: 1),
                ],
              )).toList(),
              const SizedBox(height: 100),
            ],
          );
        }),
      ],
    );
  }
} 