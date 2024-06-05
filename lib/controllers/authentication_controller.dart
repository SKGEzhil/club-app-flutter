import 'dart:convert';

import 'package:club_app/models/user_model.dart';
import 'package:club_app/screens/home_page.dart';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io' show Platform;

class AuthenticationController extends GetxController {
  var isUserLoggedIn = false.obs;

  Future<void> authenticate(BuildContext context) async {
    if (Platform.isIOS) {
      // TODO: Implement iOS authentication

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('iOS not implemented')));
      return;
    }

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;

    print(googleUser?.displayName);
    print(googleUser?.email);

    if (googleUser == null) {
      print('Sign in failed');
    } else {
      print("token: ${googleAuth?.accessToken}");
      final userExist = await isUserExist(googleUser.email);
      if (userExist) {
        final user = await getUserDetails(googleUser.email);
        await SharedPrefs.saveUserDetails(user);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else {
        print('User does not exist');
        final user = await createUser(googleUser.displayName, googleUser.email);
        await SharedPrefs.saveUserDetails(user);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    }
  }

  Future<bool> isUserExist(email) async {
    print("Authenticating...");
    const url = 'http://10.0.2.2:4000';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
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
      if(data['data']['getUser'] != null) {
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

  Future<UserModel> getUserDetails(email) async {
    print("Fetching User...");
    const url = 'http://10.0.2.2:4000';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
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
      final user = UserModel.fromJson(data['data']['getUser']);
      return user;


    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      throw Exception('Failed to authenticate user');
    }
  }

  Future<UserModel> createUser(name, email) async {
    print("Fetching User...");
    const url = 'http://10.0.2.2:4000';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
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




  Future<void> logout() async {
    await GoogleSignIn().signOut();
    isUserLoggedIn.value = false;
  }
}
