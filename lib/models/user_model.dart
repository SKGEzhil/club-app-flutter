import 'club_model.dart';

class UserClub {
  final String id;
  final String name;
  final String imageUrl;

  UserClub({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory UserClub.fromJson(Map<String, dynamic> json) {
    return UserClub(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
  };
}

class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final String photoUrl;
  final List<UserClub> clubs;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.photoUrl,
    required this.clubs,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      photoUrl: json['photoUrl'],
      clubs: json['clubs'] != null 
        ? (json['clubs'] as List).map((club) => UserClub.fromJson(club)).toList()
        : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'role': role,
    'clubs': clubs.map((club) => club.toJson()).toList(),
    'photoUrl': photoUrl
  };
}