import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../controllers/loading_controller.dart';
import 'package:get/get.dart';

class LoadingWidget extends StatelessWidget {
  LoadingWidget({Key? key}) : super(key: key);

  final loadingController = Get.put(LoadingController());

  @override
  Widget build(BuildContext context) {

    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return PopScope(
      onPopInvoked: (bool isPop) {
        if (isPop) {
          loadingController.isLoading.value = false;
        }
      },
      child: Container(
        color: currentColors.oppositeColor.withOpacity(0.2),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: const CircularProgressIndicator(
                strokeWidth: 4.0,
                color: Colors.blue,
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
        ),
      ),
    );
  }
}