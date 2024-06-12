import 'dart:convert';
import 'dart:io';
import 'package:aws_client/s3_2006_03_01.dart';
import 'package:club_app/config/constants.dart';
import 'package:club_app/models/club_model.dart';
import 'package:club_app/models/post_model.dart';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '/controllers/network_controller.dart';
import '/main.dart';
import '/models/user_model.dart';
import '/secrets.dart';
import 'package:get/get.dart';

class AdminService{

  Future<Map<String, String>> get headers async {
    final token = await SharedPrefs.getToken();
    print('token: $token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  Future<Map<String, dynamic>> updateUserRole(email, role) async {

    print("Updating role...");
    const url = '$endPoint/graphql';

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
      headers: await headers,
      body: jsonEncode({
        'query': query,
      }),
    );
    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');
      return jsonDecode(response.body);
      // Map<String, dynamic> data = jsonDecode(response.body);
      //
      // if(data['errors'] != null) {
      //   final errorMessage = data['errors'][0]['extensions']['message'];
      //   // CustomSnackBar.show(context, message: errorMessage, color: Colors.redAccent);
      // }
      //
      // return fetchAdminUsers();
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      return Future.error('Failed to update role');
    }
  }

  Future<Map<String, dynamic>> fetchAdminUsers() async {

    print("Fetching admins...");
    const url = '$endPoint/graphql';

    const query = '''
      query {
        getUsers(role: "admin") {
          id
          name
          email
          role
          photoUrl
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: await headers,
      body: jsonEncode({
        'query': query,
      }),
    );
    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');
      return jsonDecode(response.body);
      // Map<String, dynamic> data = jsonDecode(response.body);
      // final users = (data['data'])['getUsers'];
      // final adminUserList = users.map<UserModel>((user) => UserModel.fromJson(user)).toList();
      // return adminUserList;
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      return Future.error('Failed to fetch admin users');
    }
  }

}
