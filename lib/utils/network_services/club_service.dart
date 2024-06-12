import 'dart:convert';
import 'dart:io';
import 'package:aws_client/s3_2006_03_01.dart';
import 'package:club_app/config/constants.dart';
import 'package:club_app/models/club_model.dart';
import 'package:club_app/models/post_model.dart';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '/controllers/network_controller.dart';
import '/main.dart';
import '/models/user_model.dart';
import '/secrets.dart';
import 'package:get/get.dart';


class ClubService{

  Future<Map<String, String>> get headers async {
    final token = await SharedPrefs.getToken();
    print('token: $token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  Future<Map<String, dynamic>> fetchClubs() async {

    print("Fetching clubs...");
    const url = '$endPoint/graphql';

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
            role
            photoUrl
          }
          members {
            id
            name
            email
            role
            photoUrl
          }
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: await headers,
      body: jsonEncode({
        'query': query,
      }),
    );
    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');
      return jsonDecode(response.body);
      // Map<String, dynamic> data = jsonDecode(response.body);
      // final clubs = (data['data'])['getClubs'];
      // final clubList = clubs.map<Club>((club) => Club.fromJson(club)).toList();
      // return clubList;
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      return Future.error('Failed to fetch clubs');

    }
  }

  Future<Map<String, dynamic>> addMembersToClub(clubId, userEmail) async {

    print("Adding to club...");
    print("clubId: $clubId, userEmail: $userEmail");
    const url = '$endPoint/graphql';

    final query = '''
      mutation {
        addToClub(clubId: "$clubId", userEmail: "$userEmail") {
          id
          name
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: await headers,
      body: jsonEncode({
        'query': query,
      }),
    );
    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');
      return jsonDecode(response.body);
      // Map<String, dynamic> data = jsonDecode(response.body);
      //
      // if(data['errors'] != null) {
      //   final errorMessage = data['errors'][0]['extensions']['message'];
      //   // CustomSnackBar.show(context, message: errorMessage, color: Colors.redAccent);
      // }
      //
      // return fetchClubs();
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      return Future.error('Failed to add members to club');
    }
  }

  Future<Map<String, dynamic>> removeMembersFromClub(clubId, userEmail) async {

    print("Removing from club...");
    print("clubId: $clubId, userEmail: $userEmail");
    const url = '$endPoint/graphql';

    final query = '''
      mutation {
        removeFromClub(clubId: "$clubId", userEmail: "$userEmail") {
          id
          name
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: await headers,
      body: jsonEncode({
        'query': query,
      }),
    );
    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');
      return jsonDecode(response.body);
      // Map<String, dynamic> data = jsonDecode(response.body);
      //
      // if(data['errors'] != null) {
      //   final errorMessage = data['errors'][0]['extensions']['message'];
      //   // CustomSnackBar.show(context, message: errorMessage, color: Colors.redAccent);
      // }
      //
      // return fetchClubs();
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      return Future.error('Failed to remove members from club');
    }
  }

  Future<Map<String, dynamic>> updateClubInfo(id, name, description, imageUrl) async {

    print("Creating posts...");
    const url = '$endPoint/graphql';

    final query = '''
      mutation {
        updateClub(id: "$id", name: "$name", description: "$description", imageUrl: "$imageUrl") {
          id
          name
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: await headers,
      body: jsonEncode({
        'query': query,
      }),
    );
    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');
      return jsonDecode(response.body);

      // Map<String, dynamic> data = jsonDecode(response.body);
      //
      // if(data['errors'] != null) {
      //   final errorMessage = data['errors'][0]['extensions']['message'];
      //   return Future.error(errorMessage);
      //   // CustomSnackBar.show(context, message: errorMessage, color: Colors.redAccent);
      //   // throw Exception('Failed to update club');
      // }
      //
      // return fetchClubs();

    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      return Future.error('Failed to update club');
    }
  }


}