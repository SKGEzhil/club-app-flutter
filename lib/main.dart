import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:club_app/screens/home_page.dart';
import 'package:club_app/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Save Notification large icon
Future<String> _downloadAndSaveFile(String url) async {
  String filename = '${DateTime.now().millisecondsSinceEpoch}.png';
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$filename';
  final http.Response response = await http.get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

/// Getting Firebase Messaging Instance
FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

/// Firebase initialization
Future<void> initializations() async {

  // Firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.requestPermission();

  print("HELLO WORLD");

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // onMessage: When the app is open and it receives a push notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // TODO: Handle foreground messages

    print("onMessage");

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    final Map<String, dynamic>? data = message.data;

    print("title ${notification?.title}");
    print("body ${notification?.body}");

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null && data != null) {

      print("title ${notification.title}");
      print("body ${notification.body}");
      print("largeIcon ${data['largeIcon']}");

      final String url = await _downloadAndSaveFile(data['largeIcon']);


      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'launch_background',
              largeIcon: FilePathAndroidBitmap(url),
              // styleInformation: BigTextStyleInformation(
              //     notification.body!,
              //     htmlFormatBigText: true,
              //     contentTitle: notification.title,
              //     summaryText: notification.body),
              // other properties...
            ),
          ));
    }

  });

  // replacement for onResume: When the app is in the background and opened directly from the push notification.
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    // await onNotificationClick(message, 'omoa');
  });

  // Firebase message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.subscribeToTopic("clubs-app-fcm");
  FirebaseMessaging.instance
      .getInitialMessage()
      .then((message) async {
    // await onNotificationClick(message, 'get_init');
  });

  // Getting the FCM token
  final token = await FirebaseMessaging.instance.getToken();
  print("FCMToken: $token");


}



/// Callback for handling background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Notification");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializations();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}