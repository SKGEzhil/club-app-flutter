import 'package:club_app/controllers/unread_post_controller.dart';
import 'package:get/get.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<UnreadPostController>(UnreadPostController());
  }
}