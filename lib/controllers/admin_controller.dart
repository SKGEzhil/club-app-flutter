import 'dart:convert';

import 'package:club_app/controllers/profile_controller.dart';
import 'package:club_app/models/user_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AdminController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    fetchAdminUsers();
  }

  var adminUsers = <UserModel>[].obs;

  Future<void> updateUserRole(email, role) async {
    print("Updating role...");
    const url = 'http://10.0.2.2:4000/graphql';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
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
      fetchAdminUsers();
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
    }
  }

  void fetchAdminUsers() async {
    print("Fetching admins...");
    const url = 'http://10.0.2.2:4000/graphql';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
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
      adminUsers.value = users.map<UserModel>((user) => UserModel.fromJson(user)).toList();
      update();
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
    }
  }



}