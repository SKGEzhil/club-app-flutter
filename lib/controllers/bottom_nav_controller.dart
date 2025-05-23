import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  var isSheetOpen = false.obs;
  var isFeedbackSelectionVisible = false.obs;


  void selectIndex(int index) {
    selectedIndex.value = index;
    update();
  }
}