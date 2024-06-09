import 'dart:convert';

class UnreadPosts {

  UnreadPosts({
    required this.postId,
    required this.clubId,
  });

  final String postId;
  final String clubId;

  factory UnreadPosts.fromJson(Map<String, dynamic> json) {
    return UnreadPosts(
      postId: json['postId'],
      clubId: json['ClubId'],
    );
  }

  Map<String, dynamic> toJson() => {
    "postId": postId,
    "ClubId": clubId,
  };

  // static List<String> unreadPostsFromJson(String str) => List<String>.from(json.decode(str).map((x) => x));
  // static String unreadPostsToJson(List<String> data) => json.encode(List<dynamic>.from(data.map((x) => x)));
}
