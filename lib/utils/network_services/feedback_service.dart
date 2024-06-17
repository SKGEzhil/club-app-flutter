
import 'dart:convert';

import '../../config/constants.dart';
import '../shared_prefs.dart';
import 'package:http/http.dart' as http;

class FeedbackService{

  Future<Map<String, String>> get headers async {
    final token = await SharedPrefs.getToken();
    print('token: $token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }


  Future<Map<String, dynamic>> fetchFeedbackForms() async {

    print("Fetching events...");
    const url = '$endPoint/graphql';

    const query = '''
      query {
        getFeedbacks {
          id
          questions {
            question
            rating
          }
          event {
            id
            name
          }
          comments
          club {
            id
            name
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

    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      return Future.error('Failed to fetch feedbacks');
    }
  }

  Future<Map<String, dynamic>> uploadFeedback(id, ratingList) async {

    print("Fetching events...");
    const url = '$endPoint/graphql';

    final query = '''
      mutation {
        uploadFeedback(id: "$id", ratingList: $ratingList) {
          id
          questions {
            question
            rating
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

    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      return Future.error('Failed to upload feedback');
    }
  }

  Future<Map<String, dynamic>> createFeedbackForm(eventId, clubId, List<String> questionList) async {

    print("Fetching events...");
    const url = '$endPoint/graphql';

    final query = '''
      mutation {
        createFeedbackForm(event: "$eventId", club: "$clubId", questions: [${questionList.map((e) => '"$e"').join(',')}]) {
          id
          event {
            id
            name
          }
          club {
            id
            name
          }
          questions {
            question
            rating
          }
          comments
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

    } else {
      print("POST request failed");
      print('Response: ${response.body}');
      return Future.error('Failed to upload feedback');
    }
  }



}