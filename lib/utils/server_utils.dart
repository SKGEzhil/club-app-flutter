import 'dart:convert';
import 'package:club_app/models/club_model.dart';
import 'package:club_app/models/post_model.dart';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ServerUtils {

  static Future<bool> verifyGoogleUser(email, token) async {
    print("Verifying google user...");
    const url = 'http://10.0.2.2:4000/googleVerification';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');

      Map<String, dynamic> data = jsonDecode(response.body);
      SharedPrefs.saveToken(data['token']);

      return await isUserExist(email);

    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      throw Exception('Failed to verify google user');
    }
  }

  static Future<bool> isUserExist(email) async {
    print("Authenticating...");
    const url = 'http://10.0.2.2:4000/graphql';

    final token = await SharedPrefs.getToken();

    print('token: $token');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final query = '''
      query {
        getUser(email: "$email") {
          id
          name
          email
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        'query': query,
      }),
    );

    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');

      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['data']['getUser'] != null) {
        return true;
      } else {
        return false;
      }
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      throw Exception('Failed to authenticate user');
    }
  }

  static Future<UserModel> getUserDetails(email) async {
    print("Fetching User...");
    const url = 'http://10.0.2.2:4000/graphql';

    final token = await SharedPrefs.getToken();

    print('token: $token');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final query = '''
      query {
        getUser(email: "$email") {
          id
          name
          email
          role
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        'query': query,
      }),
    );

    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');

      Map<String, dynamic> data = jsonDecode(response.body);
      final user = UserModel.fromJson(data['data']['getUser']);
      return user;
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      throw Exception('Failed to authenticate user');
    }
  }

  static Future<UserModel> createUser(name, email) async {
    print("Fetching User...");
    const url = 'http://10.0.2.2:4000/graphql';

    final token = await SharedPrefs.getToken();

    print('token: $token');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final query = '''
      mutation {
        createUser(name: "$name", email: "$email") {
         id
         name
         email
      }
    }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        'query': query,
      }),
    );

    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');

      Map<String, dynamic> data = jsonDecode(response.body);
      final user = UserModel.fromJson(data['data']['createUser']);
      return user;
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      throw Exception('Failed to authenticate user');
    }
  }

  static Future<List<Club>> fetchClubs() async {
    print("Fetching clubs...");
    const url = 'http://10.0.2.2:4000/graphql';

    final token = await SharedPrefs.getToken();

    print('token: $token');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    const query = '''
      query {
        getClubs {
          id
          name
          description
          imageUrl
          createdBy {
            id
            name
            email
            role
          }
          members {
            id
            name
            email
            role
          }
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        'query': query,
      }),
    );
    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');
      Map<String, dynamic> data = jsonDecode(response.body);
      final clubs = (data['data'])['getClubs'];
      final clubList = clubs.map<Club>((club) => Club.fromJson(club)).toList();
      return clubList;
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      throw Exception('Failed to fetch clubs');
    }
  }

  static Future<List<Post>> fetchPosts() async {
    print("Fetching posts...");
    const url = 'http://10.0.2.2:4000/graphql';

    final token = await SharedPrefs.getToken();

    print('token: $token');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    const query = '''
      query {
        getPosts {
          id
          content
          createdBy {
            id
            name
            email
            role
          }
          dateCreated
          imageUrl
          club {
            id
            name
          }
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        'query': query,
      }),
    );
    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');
      Map<String, dynamic> data = jsonDecode(response.body);
      final posts = (data['data'])['getPosts'];
      final postList = posts.map<Post>((post) => Post.fromJson(post)).toList();
      return postList;
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      throw Exception('Failed to fetch posts');
    }
  }

  static Future<Post> createPost(context, content, imageUrl, createdBy, dateCreated, club) async {
    print("Creating posts...");
    const url = 'http://10.0.2.2:4000/graphql';

    final token = await SharedPrefs.getToken();

    print('token: $token');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final query = '''
      mutation {
        createPost(content: "$content", imageUrl: "$imageUrl", createdBy: "$createdBy", dateCreated: "$dateCreated", club: "$club") {
          id
          content
          imageUrl
          dateCreated
          createdBy {
            id
            name
            email
            role
          }
          club {
            id
            name
          }
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        'query': query,
      }),
    );
    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');

      Map<String, dynamic> data = jsonDecode(response.body);

      if(data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        CustomSnackBar.show(context, message: errorMessage, color: Colors.redAccent);
      }

      final post = (data['data'])['createPost'];
      return Post.fromJson(post);
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      throw Exception('Failed to create post');
    }
  }

  static Future<List<UserModel>> updateUserRole(context, email, role) async {
    print("Updating role...");
    const url = 'http://10.0.2.2:4000/graphql';

    final token = await SharedPrefs.getToken();

    print('token: $token');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final query = '''
      mutation {
        updateUser(email: "$email", role: "$role") {
          name
          role
          id
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        'query': query,
      }),
    );
    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');

      Map<String, dynamic> data = jsonDecode(response.body);

      if(data['errors'] != null) {
        final errorMessage = data['errors'][0]['extensions']['message'];
        CustomSnackBar.show(context, message: errorMessage, color: Colors.redAccent);
      }

      return fetchAdminUsers();
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      throw Exception('Failed to update role');
    }
  }

  static Future<List<UserModel>> fetchAdminUsers() async {
    print("Fetching admins...");
    const url = 'http://10.0.2.2:4000/graphql';

    final token = await SharedPrefs.getToken();

    print('token: $token');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    const query = '''
      query {
        getUsers(role: "admin") {
          id
          name
          email
          role
          fcmToken
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        'query': query,
      }),
    );
    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');
      Map<String, dynamic> data = jsonDecode(response.body);
      final users = (data['data'])['getUsers'];
      final adminUserList = users.map<UserModel>((user) => UserModel.fromJson(user)).toList();
      return adminUserList;
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      throw Exception('Failed to fetch admins');
    }
  }

}
