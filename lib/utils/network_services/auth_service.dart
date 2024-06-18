import 'dart:convert';
import 'package:club_app/config/constants.dart';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;

class AuthService{

  Future<Map<String, String>> get headers async {
    final token = await SharedPrefs.getToken();
    print('token: $token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  Future<Map<String, dynamic>> verifyGoogleUser(email, token) async {

    print("Verifying google user...");
    const url = '$endPoint/googleVerification';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');

      return jsonDecode(response.body);
      // Map<String, dynamic> data = jsonDecode(response.body);
      // SharedPrefs.saveToken(data['token']);
      //
      // return await isUserExist(email);

    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      return Future.error((jsonDecode(response.body))['message']);
    }
  }

  Future<Map<String, dynamic>> isUserExist(email) async {

    print("Authenticating...");
    const url = '$endPoint/graphql';

    final query = '''
      query {
        getUser(email: "$email") {
          id
          name
          email
          role
          photoUrl
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
      // if (data['data']['getUser'] != null) {
      //   return true;
      // } else {
      //   return false;
      // }
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      return Future.error('Failed to authenticate');
    }
  }

}