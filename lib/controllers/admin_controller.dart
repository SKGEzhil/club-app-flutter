import 'dart:convert';

import 'package:club_app/controllers/profile_controller.dart';
import 'package:club_app/models/user_model.dart';
import 'package:club_app/utils/server_utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AdminController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    fetchAdminUsers();
  }

  var adminUsers = <UserModel>[].obs;

  Future<void> fetchAdminUsers() async {
    adminUsers.value = await ServerUtils.fetchAdminUsers();
    update();
  }

  Future<void> updateUserRole(context ,email, role) async {
    adminUsers.value = await ServerUtils.updateUserRole(context, email, role);
    update();
  }



}