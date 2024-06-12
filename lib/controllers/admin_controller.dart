import 'dart:convert';

import 'package:club_app/controllers/profile_controller.dart';
import 'package:club_app/models/user_model.dart';
import 'package:club_app/utils/repositories/admin_repository.dart';
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

  Future<Map<String, dynamic>> fetchAdminUsers() async {
    try{
      adminUsers.value = await AdminRepository().fetchAdminUsers();
      update();
      return {'status': 'ok', 'message': 'User added to club successfully'};
    } catch(e) {
      return {'status': 'error', 'message': e.toString()};
    }

  }

  Future<Map<String, dynamic>> updateUserRole(context ,email, role) async {
    try{
      adminUsers.value = await AdminRepository().updateUserRole(email, role);
      update();
      return {'status': 'ok', 'message': 'User role updated successfully'};
    } catch(e){
      return {'status': 'error', 'message': e.toString()};
    }
  }



}