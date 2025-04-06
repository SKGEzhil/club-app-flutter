import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'image_viewer.dart';

class Links {
  static const String linkedIn = 'https://www.linkedin.com/in/skgezhil2005/';
  static const String github = 'https://www.github.com/SKGEzhil';
  static const String instagram = 'https://instagram.com/skgezhil2005';
  static const String sourceCode =
      'https://github.com/SKGEzhil/club-app-flutter';
  final Uri _emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'skgezhil2005@gmail.com',
    queryParameters: {'subject': "", 'body': ""},
  );
}

class Info{

  var taps = 0;
  Timer? _timer;

  void handleTap(){
    taps++;
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer(Duration(seconds: 1), () {
      taps = 0; // Reset taps if more than 1 second passes between taps
    });
    if (taps == 7) {
      taps = 0;
      Navigator.of(Get.context!).push(MaterialPageRoute(
          builder: (context) => const SecretInfoPage()));
    }
  }
}

class SecretInfoPage extends StatelessWidget {
  const SecretInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Align(
            alignment: Alignment.center,
            child: Text('Club App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
        ),
        body: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(70.0),
                ),
                child: const CircleAvatar(
                  radius: 70,
                  backgroundImage: CachedNetworkImageProvider('https://via.placeholder.com/500'),
                ),
              ),
              const Text('App Info',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              const Text('Version: 1.0.1',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
              const Text('This project is licensed under the MIT License',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onTap: () => launchUrl(Uri.parse(Links.sourceCode)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color.fromRGBO(27, 31, 34, 1.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset('assets/github_icon_2.png',
                                    height: 25, width: 25),
                                const SizedBox(width: 5),
                                const Text(
                                  'Source Code',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(width: 3),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          onTap: () {
                            // final InAppReview inAppReview =
                            //     InAppReview.instance;
                            // inAppReview.openStoreListing();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color.fromRGBO(255, 181, 0, 1.0),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Rate App',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(width: 3),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black.withOpacity(0.1),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 4),
                            child: Text('Developer Info',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                          builder: (context) => const ImageViewer(
                                            image: 'https://clubs-app-bucket.s3.ap-south-1.amazonaws.com/pfp.png',
                                          )));
                                    },
                                    child: const CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                      AssetImage('assets/pfp.png'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text('Karthik Gnana Ezhil S',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                        'BTech Engineering Physics 2027',
                                      ),
                                      Text('IIT Hyderabad',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700)),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 12.0),
                                child: Divider(),
                              ),
                              const Text(
                                'Contact',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 3, 12, 0),
                                child: InkWell(
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  onTap: () {
                                    launchUrl(Links()._emailLaunchUri);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrangeAccent
                                          .withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(width: 5),
                                          Text('Email: ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          Text('skgezhil2005@gmail.com',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400)),
                                          SizedBox(width: 5),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  InkWell(
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    onTap: () =>
                                        launchUrl(Uri.parse(Links.linkedIn)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color:
                                        const Color.fromRGBO(255, 255, 255, 1.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                                'assets/linkedin_icon.png',
                                                height: 25,
                                                width: 25),
                                            const SizedBox(width: 7),
                                            const Text(
                                              'LinkedIn',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(width: 3),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  InkWell(
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    onTap: () =>
                                        launchUrl(Uri.parse(Links.github)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: const Color.fromRGBO(27, 31, 34, 1.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                                'assets/github_icon_2.png',
                                                height: 25,
                                                width: 25),
                                            const SizedBox(width: 5),
                                            const Text(
                                              'GitHub',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(width: 3),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  InkWell(
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    onTap: () =>
                                        launchUrl(Uri.parse(Links.instagram)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color:
                                        const Color.fromRGBO(253, 44, 136, 1.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(width: 3),
                                            Image.asset(
                                                'assets/instagram_icon.webp',
                                                height: 25,
                                                width: 25),
                                            const SizedBox(width: 5),
                                            const Text(
                                              'Instagram',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(width: 3),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
