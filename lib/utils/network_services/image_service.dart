import 'dart:convert';
import 'dart:io';
import 'package:aws_client/s3_2006_03_01.dart';
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

class ImageService{


  static Future<String> uploadImage(XFile image) async {

    String filename = '${DateTime.now().millisecondsSinceEpoch}.png';
    final credentials = AwsClientCredentials(accessKey: AWS_ACCESS_KEY, secretKey: AWS_SECRET_KEY);
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

}