import 'dart:io';
import 'package:club_app/utils/server_utils.dart';
import 'package:club_app/utils/shared_prefs.dart';
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

/// Show local notification
Future<void> showLocalNotification(RemoteMessage message) async {
  final Map<String, dynamic>? data = message.data;

  if (data != null) {
    print("largeIcon ${data['largeIcon']}");
    print("image ${data['image']}");
    print("title ${data['title']}");
    print("body ${data['body']}");
    final String largeIcon = await _downloadAndSaveFile(data['largeIcon']);
    final String image = await _downloadAndSaveFile(data['image']);

    flutterLocalNotificationsPlugin.show(
        data.hashCode,
        data['title'],
        data['body'],
        NotificationDetails(
          android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'launch_background',
              largeIcon: FilePathAndroidBitmap(largeIcon),
              color: Colors.deepPurple,
              colorized: true,
              styleInformation: BigPictureStyleInformation(
                FilePathAndroidBitmap(image),
              )
          ),
        ));
  }
}

/// Local Notifications Initialization
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


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


  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // onMessage: When the app is open and it receives a push notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // TODO: Handle foreground messages
    print("onMessage");
    showLocalNotification(message);
  });

  // replacement for onResume: When the app is in the background and opened directly from the push notification.
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
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
  showLocalNotification(message);
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializations();
  final Widget landingPage;
  final token = await SharedPrefs.getToken();
  print("TOKEN $token");
  if(token != ''){
    final user = await SharedPrefs.getUserDetails();
    final updatedUser = await ServerUtils.getUserDetails(user.email);
    await SharedPrefs.saveUserDetails(updatedUser);
    landingPage = HomePage();
  } else {
    landingPage = LoginPage();
  }
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(landingPage: landingPage,));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.landingPage});

  final Widget landingPage;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: landingPage,
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