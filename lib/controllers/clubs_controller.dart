import 'dart:convert';

import 'package:club_app/controllers/post_controller.dart';
import 'package:club_app/utils/server_utils.dart';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/club_model.dart';
import 'network_controller.dart';

class ClubsController extends GetxController {

  var clubList = <Club>[].obs;

  final postController = Get.put(PostController());


  @override
  void onInit() {
    super.onInit();
    final networkController = Get.find<NetworkController>();
    networkController.isOnline.value ?
    fetchClubs() : fetchClubsFromSharedPrefs();
  }

  void fetchClubs() async {
    clubList.value = await ServerUtils.fetchClubs();
    await SharedPrefs.saveClubs(clubList);
    update();
  }

  void fetchClubsFromSharedPrefs() async {
    clubList.value = await SharedPrefs.getClubs();
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

  Future<void> updateClub(context, id, name, description, imageUrl) async {
    clubList.value = await ServerUtils.updateClubInfo(context, id, name, description, imageUrl);
    update();
  }

}

