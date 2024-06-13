import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../colors.dart';
import '../controllers/bottom_nav_controller.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  final bottomNavController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {

    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return Container(
      decoration: BoxDecoration(
        color: currentColors.mainColor,
      ),
      child: GetBuilder<BottomNavController>(builder: (logic) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  bottomNavController.selectIndex(0);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.event, size: 30,
                      color: bottomNavController.selectedIndex.value == 0 ? Colors.blue : currentColors.oppositeColor
                    ),
                    Text('Events',
                      style: TextStyle(
                        color: bottomNavController.selectedIndex.value == 0 ? Colors.blue : currentColors.oppositeColor
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  bottomNavController.selectIndex(1);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat_bubble, size: 30,
                      color: bottomNavController.selectedIndex.value == 1 ? Colors.blue : currentColors.oppositeColor
                    ),
                    Text('Clubs',
                      style: TextStyle(
                        color: bottomNavController.selectedIndex.value == 1 ? Colors.blue : currentColors.oppositeColor
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
