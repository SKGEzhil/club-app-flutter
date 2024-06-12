import 'dart:convert';
import 'dart:io';
import 'package:aws_client/s3_2006_03_01.dart';
import 'package:club_app/models/club_model.dart';
import 'package:club_app/models/post_model.dart';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../network_services/auth_service.dart';
import '/controllers/network_controller.dart';
import '/main.dart';
import '/models/user_model.dart';
import '/secrets.dart';
import 'package:get/get.dart';

class AuthRepository{

  static bool isInternetConnectionAvailable() {
    // Check internet connection
    final networkController = Get.find<NetworkController>();
    return networkController.isOnline.value;
  }

  Future<bool> verifyGoogleUser(email, token) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    // Verify google user
    try{
      Map<String, dynamic> data = await AuthService().verifyGoogleUser(email, token);
      if(data['status'] == 'error'){
        return Future.error(data['message']);
      }
      SharedPrefs.saveToken(data['token']);
      return await isUserExist(email);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> isUserExist(email) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    // Check if user exists
    try{
      Map<String, dynamic> data = await AuthService().isUserExist(email);
      if(data['data']['getUser'] != null){
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return Future.error(e);
    }
  }

}