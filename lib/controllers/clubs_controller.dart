import 'dart:convert';

import 'package:club_app/controllers/post_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/club_model.dart';

class ClubsController extends GetxController {

  var clubList = <Club>[].obs;

  final postController = Get.put(PostController());

  // final clubs = <Club>[
  //   Club(name: 'Electronics & Robotics_IITBombay', imageUrl: "https://via.placeholder.com/50x50" ),
  //   Club(name: 'WNCC_IITBombay', imageUrl: "https://via.placeholder.com/50x50"),
  //   Club(name: 'Rakshak_IITBombay', imageUrl: "https://via.placeholder.com/50x50"),
  //   Club(name: 'Tinkerers Lab_IITBombay', imageUrl: "https://via.placeholder.com/50x50"),
  //   Club(name: 'Racing_IITBombay', imageUrl: "https://via.placeholder.com/50x50"),
  //   Club(name: 'BioX_IITBombay', imageUrl: "https://via.placeholder.com/50x50"),
  //   Club(name: 'Techfest_IITBombay', imageUrl: "https://via.placeholder.com/50x50"),
  //   Club(name: 'Sustainability Cell_IITBombay', imageUrl: "https://via.placeholder.com/50x50"),
  //   Club(name: 'Electronics & Robotics_IITBombay', imageUrl: "https://via.placeholder.com/50x50" ),
  //   Club(name: 'WNCC_IITBombay', imageUrl: "https://via.placeholder.com/50x50"),
  //   Club(name: 'Rakshak_IITBombay', imageUrl: "https://via.placeholder.com/50x50"),
  //   Club(name: 'Tinkerers Lab_IITBombay', imageUrl: "https://via.placeholder.com/50x50"),
  //   Club(name: 'Racing_IITBombay', imageUrl: "https://via.placeholder.com/50x50"),
  //   Club(name: 'BioX_IITBombay', imageUrl: "https://via.placeholder.com/50x50"),
  //   Club(name: 'Techfest_IITBombay', imageUrl: "https://via.placeholder.com/50x50"),
  //   Club(name: 'Sustainability Cell_IITBombay', imageUrl: "https://via.placeholder.com/50x50"),
  // ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchClubs();
  }

  void fetchClubs() async {
    print("Fetching clubs...");
    const url = 'http://10.0.2.2:4000/graphql';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    const query = '''
      query {
        getClubs {
          id
          name
          description
          imageUrl
          createdBy {
            id
            name
            email
          }
          members {
            id
            name
            email
          }
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        'query': query,
      }),
    );    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');
      Map<String, dynamic> data = jsonDecode(response.body);
      final clubs = (data['data'])['getClubs'];
      clubList.value = clubs.map<Club>((club) => Club.fromJson(club)).toList();
      update();
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
    }
  }
}

