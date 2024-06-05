import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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

    final userDetails = UserModel.fromJson(jsonDecode(prefs.getString("user_details")!));
    print("USER NaMe: ${userDetails.name}");

    return userDetails;
  }
}