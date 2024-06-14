import 'package:aws_client/dynamo_document.dart';
import 'package:club_app/models/club_model.dart';
import 'package:club_app/models/event_model.dart';
import 'package:club_app/models/unread_post_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/post_model.dart';
import '../models/user_model.dart';

class SharedPrefs {
  static Future<void> saveUserDetails(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    final userDetails = jsonEncode(user.toJson());
    print(userDetails);

    prefs.setString("user_details", userDetails.toString());
  }

  static Future<UserModel> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();

    final userDetails =
        UserModel.fromJson(jsonDecode(prefs.getString("user_details")!));
    print("USER NaMe: ${userDetails.name}");

    return userDetails;
  }

  static saveToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    print('SAVED TOKEN: $token');
    prefs.setString("token", token!);
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("token") == null) return '';
    return prefs.getString("token")!;
  }

  static setUnreadPosts(List<UnreadPosts> unreadPosts) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> unreadPostListString = unreadPosts
        .map((unreadPost) => json.encode(unreadPost.toJson()))
        .toList();
    unreadPostListString.forEach((element) async {
      print('element: $element');
    });
    await prefs.setStringList('unread_posts', unreadPostListString);
    print('Saved!!');
  }

  static Future<List<UnreadPosts>> getUnreadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> unreadPostListString = prefs.getStringList('unread_posts') ?? [];
    List<UnreadPosts> unreadPosts = unreadPostListString
        .map((unreadPost) => UnreadPosts.fromJson(json.decode(unreadPost)))
        .toList();
    return unreadPosts;
  }

  static Future<void> savePost(List<Post> post) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> postListString =
        post.map((post) => json.encode(post.toJson())).toList();
    await prefs.setStringList('posts', postListString);
    print('Saved posts');
  }

  static Future<List<Post>> getPost() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> postListString = prefs.getStringList('posts') ?? [];
    List<Post> posts =
        postListString.map((post) => Post.fromJson(json.decode(post))).toList();
    return posts;
  }

  static Future<void> saveClubs(List<Club> clubs) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> clubListString =
        clubs.map((club) => json.encode(club.toJson())).toList();
    await prefs.setStringList('clubs', clubListString);
    print('Saved clubs');
  }

  static Future<List<Club>> getClubs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> clubListString = prefs.getStringList('clubs') ?? [];
    List<Club> clubs =
        clubListString.map((club) => Club.fromJson(json.decode(club))).toList();
    return clubs;
  }

  static Future<void> saveEvents(List<EventModel> events) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> eventListString =
        events.map((event) => json.encode(event.toJson())).toList();
    await prefs.setStringList('events', eventListString);
    print('Saved events');
  }

  static Future<List<EventModel>> getEvents() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> eventListString = prefs.getStringList('events') ?? [];
    print('Events: ${eventListString.length}');
    eventListString.forEach(
      (element) {
        print('Event: $element');
      },
    );
    List<EventModel> events =
        eventListString.map((event) => EventModel.fromJson(json.decode(event))).toList();
    events.forEach((element) {
      print('Event: ${element.name}');
    });
    return events;
  }

  static clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
