import 'dart:convert';

import 'package:club_app/controllers/post_controller.dart';
import 'package:club_app/utils/server_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/club_model.dart';

class ClubsController extends GetxController {

  var clubList = <Club>[].obs;

  final postController = Get.put(PostController());


  @override
  void onInit() {
    super.onInit();
    fetchClubs();
  }

  void fetchClubs() async {
    clubList.value = await ServerUtils.fetchClubs();
    update();
  }

  void addUserToClub(context, clubId, userEmail) async {
    clubList.value = await ServerUtils.addMembersToClub(context, clubId, userEmail);
    update();
  }

  void removeUserFromClub(context, clubId, userEmail) async {
    clubList.value = await ServerUtils.removeMembersFromClub(context, clubId, userEmail);
    update();
  }

}

