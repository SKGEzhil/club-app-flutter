import 'dart:io';

import 'package:aws_s3_upload_lite/aws_s3_upload_lite.dart';
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
    update();
  }

  Future<void> createPost(content, createdBy, club) async {
    final dateTime = DateTime.now();
    final formattedDateTime = DateFormat('yyyy-MM-ddThh:mm').format(dateTime);
    print(formattedDateTime);
    var imageUrl = '';
    if (imagePickerController.image != null) {
      imageUrl = await uploadImage(imagePickerController.image!);
    }
    postList.add(await ServerUtils.createPost(content, imageUrl, createdBy, formattedDateTime, club));
    update();
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