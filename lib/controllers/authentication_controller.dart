import 'dart:convert';

import 'package:club_app/models/user_model.dart';
import 'package:club_app/screens/home_page.dart';
import 'package:club_app/utils/server_utils.dart';
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
      final userExist = await ServerUtils.isUserExist(googleUser.email);
      if (userExist) {
        final user = await ServerUtils.getUserDetails(googleUser.email);
        login(context, user, googleAuth);
      } else {
        print('User does not exist');
        final user = await ServerUtils.createUser(googleUser.displayName, googleUser.email);
        login(context, user, googleAuth);
      }
    }
  }

  Future<void> login(context, user, googleAuth) async {
    await SharedPrefs.saveUserDetails(user);
    await SharedPrefs.saveToken(googleAuth?.accessToken);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  Future<void> logout()async {
    await GoogleSignIn().signOut();
    await SharedPrefs.clearAll();
  }



}
