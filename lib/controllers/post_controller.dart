import 'dart:io';

import 'package:aws_s3_upload_lite/aws_s3_upload_lite.dart';
import 'package:club_app/secrets.dart';
import 'package:club_app/utils/server_utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../models/post_model.dart';
import 'package:aws_client/s3_2006_03_01.dart';

import 'image_picker_controller.dart';
import 'package:intl/intl.dart';

class PostController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  final imagePickerController = Get.put(ImagePickerController());
  var postList = <Post>[].obs;

  void fetchPosts() async {
    postList.value = await ServerUtils.fetchPosts();
    print("LENGTH: ${postList.length}");
    update();
  }

  Future<void> createPost(context, content, createdBy, club) async {
    final dateTime = DateTime.now();
    final formattedDateTime = DateFormat('yyyy-MM-ddThh:mm').format(dateTime);
    print(formattedDateTime);
    var imageUrl = '';
    if (imagePickerController.image != null) {
      imageUrl = await ServerUtils.uploadImage(imagePickerController.image!);
    }
    postList.add(await ServerUtils.createPost(context, content, imageUrl, createdBy, formattedDateTime, club));
    update();
  }


  Future<void> checkAwsCredentials() async {
    final credentials = AwsClientCredentials(accessKey: AWS_ACCESS_KEY, secretKey: AWS_SECRET_KEY);
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