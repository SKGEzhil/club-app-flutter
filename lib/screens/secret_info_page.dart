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

  // Custom accent color - yellowish shade
  static const Color accentColor = Color(0xFFF5C518);

  Widget _buildSocialButton({
    required String text,
    required String iconPath,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
    bool isAssetImage = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isAssetImage)
              Image.asset(iconPath, height: 20, width: 20)
            else
              Icon(Icons.star, size: 20, color: textColor),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Club App',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Info Section
              Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: CachedNetworkImageProvider('https://via.placeholder.com/500'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'App Info',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version: 1.0.1',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      'This project is licensed under the MIT License',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(
                    text: 'Source Code',
                    iconPath: 'assets/github_icon_2.png',
                    backgroundColor: isDark ? Colors.white12 : Colors.black,
                    textColor: isDark ? Colors.white : Colors.white,
                    onTap: () => launchUrl(Uri.parse(Links.sourceCode)),
                  ),
                  const SizedBox(width: 12),
                  _buildSocialButton(
                    text: 'Rate App',
                    iconPath: '',
                    backgroundColor: accentColor,
                    textColor: Colors.black,
                    onTap: () {},
                    isAssetImage: false,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Developer Info Section
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Developer Info',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ImageViewer(
                                  image: 'https://clubs-app-bucket.s3.ap-south-1.amazonaws.com/pfp.png',
                                ),
                              ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: accentColor.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const CircleAvatar(
                                radius: 40,
                                backgroundImage: AssetImage('assets/pfp.png'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Karthik Gnana Ezhil S',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'BTech Engineering Physics 2027',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                                Text(
                                  'IIT Hyderabad',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Contact',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => launchUrl(Links()._emailLaunchUri),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: accentColor,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.email_outlined,
                                color: accentColor,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'skgezhil2005@gmail.com',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Social Media Icons
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildSocialButton(
                            text: 'LinkedIn',
                            iconPath: 'assets/linkedin_icon.png',
                            backgroundColor: const Color(0xFF0A66C2),
                            textColor: Colors.white,
                            onTap: () => launchUrl(Uri.parse(Links.linkedIn)),
                          ),
                          _buildSocialButton(
                            text: 'GitHub',
                            iconPath: 'assets/github_icon_2.png',
                            backgroundColor: isDark ? Colors.white12 : Colors.black,
                            textColor: isDark ? Colors.white : Colors.white,
                            onTap: () => launchUrl(Uri.parse(Links.github)),
                          ),
                          _buildSocialButton(
                            text: 'Instagram',
                            iconPath: 'assets/instagram_icon.webp',
                            backgroundColor: const Color(0xFFE4405F),
                            textColor: Colors.white,
                            onTap: () => launchUrl(Uri.parse(Links.instagram)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
