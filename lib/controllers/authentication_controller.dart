import 'dart:convert';

import 'package:club_app/models/user_model.dart';
import 'package:club_app/screens/home_page.dart';
import 'package:club_app/utils/repositories/auth_repository.dart';
import 'package:club_app/utils/repositories/user_repository.dart';
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

  Future<Map<String, dynamic>> authenticate(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser;
      if(Platform.isIOS){
        googleUser = await GoogleSignIn(
            clientId: '255948244097-53c89fc4f7kuc0gqr290iu5gj87hrkdb.apps.googleusercontent.com'
        ).signIn();
      } else {
        googleUser = await GoogleSignIn().signIn();
      }
      final googleAuth = await googleUser?.authentication;

      print(googleUser?.displayName);
      print(googleUser?.email);

      if (googleUser == null) {
        print('Sign in failed');
        return {'status': 'error', 'message': 'Sign in failed'};
      } else {
        print("token: ${googleAuth?.accessToken}");
        print("photo: ${googleUser.photoUrl}");

        try{
          final userExist = await AuthRepository()
              .verifyGoogleUser(googleUser.email, googleAuth?.accessToken);
          if (userExist) {
            final user = await UserRepository().getUserDetails(googleUser.email);
            login(context, user, googleAuth);
            return {'status': 'ok', 'message': 'Logged in successfully'};
          } else {
            print('User does not exist');
            final user = await UserRepository().createUser(
                googleUser.displayName, googleUser.email, googleUser.photoUrl);
            login(context, user, googleAuth);
            return {'status': 'ok', 'message': 'Account created successfully'};
          }
        } catch(e) {
          print(e);
          return {'status': 'error', 'message': e.toString()};
        }


      }
    } catch (e) {
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<void> login(context, user, googleAuth) async {
    await SharedPrefs.saveUserDetails(user);
    // await SharedPrefs.saveToken(googleAuth?.accessToken);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await SharedPrefs.clearAll();
  }
}
