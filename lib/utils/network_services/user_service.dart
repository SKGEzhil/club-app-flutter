import 'dart:convert';
import 'package:club_app/config/constants.dart';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;

class UserService{

  Future<Map<String, String>> get headers async {
    final token = await SharedPrefs.getToken();
    print('token: $token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  Future<Map<String, dynamic>> getUserDetails(email) async {

    print("Fetching User...");
    const url = '$endPoint/graphql';

    final query = getUserQuery(email);

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
      // final user = UserModel.fromJson(data['data']['getUser']);
      // return user;
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      return Future.error('Failed to fetch user');
    }
  }

  Future<Map<String, dynamic>> createUser(name, email, photoUrl) async {

    print("Fetching User...");
    const url = '$endPoint/graphql';

    final query = createUserQuery(name, email, photoUrl);

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
      // final user = UserModel.fromJson(data['data']['createUser']);
      // return user;
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      return Future.error('Failed to create user');
    }
  }

}