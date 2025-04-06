import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/controllers/authentication_controller.dart';
import 'package:club_app/controllers/notification_controller.dart';
import 'package:club_app/controllers/profile_controller.dart';
import 'package:club_app/controllers/theme_controller.dart';
import 'package:club_app/screens/admin_page.dart';
import 'package:club_app/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final profileController = Get.put(ProfileController());
  final themeController = Get.put(ThemeController());
  final authController = Get.put(AuthenticationController());
  final notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Obx(() {
                final user = profileController.currentUser.value;
                return Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: user.photoUrl.isEmpty
                            ? Icon(
                                Icons.person,
                                size: 50,
                                color: Theme.of(context).primaryColor,
                              )
                            : CachedNetworkImage(
                                imageUrl: user.photoUrl,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email.split('@')[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.dark_mode,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text('Dark Mode'),
                      subtitle: Text('App color theme'),
                      trailing: Switch(
                        value: Theme.of(context).brightness == Brightness.dark,
                        onChanged: (value) {
                          themeController.changeThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text('Notification'),
                      subtitle: Text('Notification settings'),
                      trailing: Obx(() => Switch(
                        value: notificationController.isNotificationsEnabled,
                        onChanged: (value) {
                          notificationController.toggleNotifications(value);
                        },
                      )),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.help_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text('Help'),
                      subtitle: Text('Help center, contact us, privacy policy'),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).primaryColor,
                      ),
                      onTap: () {
                        // TODO: Implement help section
                      },
                    ),
                    Obx(() {
                      final user = profileController.currentUser.value;
                      if (user.role == 'admin') {
                        return Column(
                          children: [
                            const Divider(height: 1),
                            ListTile(
                              leading: Icon(
                                Icons.admin_panel_settings,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text('Admin Panel'),
                              subtitle: Text('Manage users and clubs'),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: Theme.of(context).primaryColor,
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const AdminPage(),
                                ));
                              },
                            ),
                          ],
                        );
                      }
                      return const SizedBox();
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onTap: () async {
                    await authController.logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
} 