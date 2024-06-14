import 'dart:convert';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';

class EventService{

  Future<Map<String, String>> get headers async {
    final token = await SharedPrefs.getToken();
    print('token: $token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  Future<Map<String, dynamic>> fetchEvents() async {

    print("Fetching events...");
    const url = '$endPoint/graphql';

    const query = '''
      query {
        getEvents {
          id
          name
          description
          date
          createdAt
          bannerUrl
          location
          club {
            id
            name
            imageUrl
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
      return Future.error('Failed to fetch events');
    }
  }

  Future<Map<String, dynamic>> createEvent(name, description, date, location, bannerUrl, club) async {

    print("Creating event...");
    const url = '$endPoint/graphql';

    print('name: $name');
    print('description: $description');
    print('date: $date');
    print('location: $location');
    print('bannerUrl: $bannerUrl');
    print('club: $club');

    final query = '''
      mutation {
        createEvent(
          name: "$name",
          description: "$description",
          date: "$date",
          location: "$location",
          bannerUrl: "$bannerUrl",
          club: "$club"
        ) {
          id
          name
          description
          date
          createdAt
          bannerUrl
          location
          club {
            id
            name
            imageUrl
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
      return Future.error('Failed to create post');
    }
  }

  Future<Map<String, dynamic>> updateEvent(id, name, description, date, location, club) async {

    print("updating event...");
    const url = '$endPoint/graphql';

    print('id: $id');
    print('name: $name');
    print('description: $description');
    print('date: $date');
    print('location: $location');

    final query = '''
      mutation {
        updateEvent(
          id: "$id",
          name: "$name",
          description: "$description",
          date: "$date",
          location: "$location",
          club: "$club"
        ) {
          id
          name
          description
          date
          createdAt
          bannerUrl
          location
          club {
            id
            name
            imageUrl
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
      return Future.error('Failed to update event');
    }
  }

  Future<Map<String, dynamic>> deleteEvent(id) async {

    print("Deleting event...");
    const url = '$endPoint/graphql';

    final query = '''
      mutation {
        deleteEvent(
          id: "$id"
        ) 
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
      return Future.error('Failed to delete post');
    }
  }


}