import 'dart:io';

import 'package:aws_s3_upload_lite/aws_s3_upload_lite.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../models/post_model.dart';
import 'package:aws_client/s3_2006_03_01.dart';

class PostController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  var postList = <Post>[].obs;



  void fetchPosts() async {
    print("Fetching posts...");
    const url = 'http://10.0.2.2:4000/graphql';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    const query = '''
      query {
        getPosts {
          id
          content
          createdBy {
            id
            name
            email
            role
          }
          dateCreated
          imageUrl
          club {
            id
            name
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
    );
    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');
      Map<String, dynamic> data = jsonDecode(response.body);
      final posts = (data['data'])['getPosts'];
      postList.value = posts.map<Post>((post) => Post.fromJson(post)).toList();
      // sortPostsByDate();
      update();
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
    }
  }

  void sortPostsByDate() {
    postList.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    update();
  }

  Future<void> createPost(content, imageUrl, createdBy, dateCreated, club) async {
    print("Creating posts...");
    const url = 'http://10.0.2.2:4000/graphql';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final query = '''
      mutation {
        createPost(content: "$content", imageUrl: "$imageUrl", createdBy: "$createdBy", dateCreated: "$dateCreated", club: "$club") {
          id
          content
          imageUrl
          dateCreated
          createdBy {
            id
            name
            email
            role
          }
          club {
            id
            name
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
    );
    if (response.statusCode == 200) {
      print("POST request successful");
      print('Response: ${response.body}');
      Map<String, dynamic> data = jsonDecode(response.body);
      final post = (data['data'])['createPost'];
      postList.add(Post.fromJson(post));
      // sortPostsByDate();
      update();
    } else {
      print("POST request failed");
      print('Response: ${response.body}');
    }
  }

  Future<String> uploadImage(XFile image) async {
      String filename = '${DateTime.now().millisecondsSinceEpoch}.png';
    final credentials = AwsClientCredentials(accessKey: 'AKIA4YVVFSBGWG4OQVDT', secretKey: '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');
    final api = S3(region: 'ap-south-1', credentials: credentials);
    await api.putObject(
        bucket: 'clubs-app-bucket',
        key: filename,
        body: File(image.path).readAsBytesSync(),
    );
    api.close();
    print("https://clubs-app-bucket.s3.ap-south-1.amazonaws.com/$filename");
    return "https://clubs-app-bucket.s3.ap-south-1.amazonaws.com/$filename";
  }

  Future<void> checkAwsCredentials() async {
    final credentials = AwsClientCredentials(accessKey: 'AKIA4YVVFSBGWG4OQVDT', secretKey: 'Hriw5AuEmN1EvxqUTy7llLFBA/NmiIVes+/2f5YV');
    final s3 = S3(region: 'ap-south-1', credentials: credentials); // e.g., 'us-west-2'

    try {
      final response = await s3.listBuckets();
      Bucket bucket = response.buckets!.first;
      print('AWS credentials are valid. Buckets: ${bucket.name}');
    } catch (e) {
      print('Failed to list buckets: $e');
    }
  }

}