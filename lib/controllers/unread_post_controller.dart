import 'package:club_app/models/unread_post_list_model.dart';
import 'package:get/get.dart';

import '../utils/shared_prefs.dart';

class UnreadPostController extends GetxController {

  // @override
  // void onInit() {
  //   super.onInit();
  //   getUnreadPosts();
  // }

  final unreadCount = 0.obs;
  final unreadPostList = <UnreadPosts>[].obs;

  Future<void> addUnreadPost(String postId, String clubId) async {
    print('Initial Unread Post List: ${unreadPostList.length}');
    unreadPostList.add(UnreadPosts(postId: postId, clubId: clubId));
    unreadPostList.forEach((element) {
      print('ADD UNREAD POST: ${element.postId}');
    });
    unreadCount.value = unreadPostList.length;
    await SharedPrefs.setUnreadPosts(unreadPostList);
    update();
  }

  Future<void> getUnreadPosts() async {
    final unreadPosts = await SharedPrefs.getUnreadPosts();
    unreadPosts.forEach((element) {
      print('GET UNREAD POST: ${element.postId}');
    });
    unreadPostList.assignAll(unreadPosts);
    unreadPostList.forEach((element) {
      print('GOT UNREAD POST: ${element.postId}');
    });
    unreadCount.value = unreadPostList.length;
    update();
  }

  Future<void> removeUnreadPost(String clubId) async {
    unreadPostList.removeWhere((element) => element.clubId == clubId);
    unreadCount.value = unreadPostList.length;
    await SharedPrefs.setUnreadPosts(unreadPostList);
    update();
  }


}