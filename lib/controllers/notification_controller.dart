import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController {
  final _isNotificationsEnabled = false.obs;
  bool get isNotificationsEnabled => _isNotificationsEnabled.value;

  @override
  void onInit() {
    super.onInit();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isNotificationsEnabled.value = prefs.getBool('notifications_enabled') ?? false;
  }

  Future<void> toggleNotifications(bool value) async {
    if (value) {
      // Request notification permission
      final status = await Permission.notification.request();
      if (status.isGranted) {
        // Enable notifications
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        await FirebaseMessaging.instance.subscribeToTopic("trial-1");
        _isNotificationsEnabled.value = true;
      } else {
        // Show message that permission is required
        Get.snackbar(
          'Permission Required',
          'Please enable notifications in your device settings to receive updates',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    } else {
      // Disable notifications
      await FirebaseMessaging.instance.unsubscribeFromTopic("trial-1");
      _isNotificationsEnabled.value = false;
    }

    // Save the setting
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _isNotificationsEnabled.value);
  }
} 