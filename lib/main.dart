import 'dart:async';
import 'dart:io';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:restaurant/modules/Resturant/statement/resturant_provider.dart';
import 'package:restaurant/modules/categories/provider/categories_provider.dart';
import 'package:restaurant/modules/contactUs/providers/contact_provider.dart';
import 'package:restaurant/modules/customers/provider/customers_provider.dart';
import 'package:restaurant/modules/notifications/provider/notificaction_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/modules/drawer/drawer.dart';
import 'package:restaurant/modules/Authentication/screen/login_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './themes/style.dart';
import './routes.dart';
import 'package:provider/provider.dart';
import './modules/dashboard/provider/dashboard_provider.dart';
import 'modules/coupons/statement/couponProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String status = 'checkingSharedPrefs';

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') == null) {
      setState(() {
        status = 'userNotLogedIn';
      });
    } else {
      setState(() {
        status = 'userLogedIn';
      });
    }
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String fcmContactName;
  String fcmContactId;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  Future onSelectNotification(String payload) async {
    Navigator.pushNamed(
      context,
      payload,
      arguments: {
        "contactId": fcmContactId,
        "name": fcmContactName,
      },
    );
  }

  void notifyInitialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void showNotification(
      {message, String routeName, BuildContext context, String userId}) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      message['title'].toString(),
      message['body'].toString(),
      platformChannelSpecifics,
      payload: routeName,
      // payload: routeName + "::" + userId + "//" + message['title'],
    );
    print("Mahdi: routeName: $routeName");
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    fcmContactName = message['notification']['title'];
    fcmContactId = message['data']['contactId'];

    Navigator.pushNamed(
      context,
      message['data']['screen'],
      arguments: {
        "contactId": fcmContactId,
        "name": fcmContactName,
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getPrefs();

    Future.delayed(Duration.zero, () {
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage:: $message");
          print("onMessage:: ${message['data']['screen']}");

          fcmContactName = message['notification']['title'];
          fcmContactId = message['data']['contactId'];

          Platform.isAndroid
              ? showNotification(
                  message: message['notification'],
                  routeName: message['data']['screen'],
                  userId: message['data']['contactId'],
                  context: context,
                )
              : showNotification(
                  message: message['aps']['alert'],
                  routeName: message['data']['screen'],
                  userId: message['data']['contactId'],
                  context: context,
                );

          // _navigateToItemDetail(message);
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          print("onLaunch:: ${message['data']['screen']}");
          _navigateToItemDetail(message);
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          print("onResume:: ${message['data']['screen']}");
          _navigateToItemDetail(message);
        },
      );
    });

    super.initState();
  }

  // StreamSubscription _sub;
  // Future<Null> initUniLinks() async {
  //   // Uri parsing may fail, so we use a try/catch FormatException.
  //   try {
  //     Uri initialUri = await getInitialUri();
  //     String myUri = initialUri.toString();
  //   } on FormatException {
  //     // Handle exception by warning the user their action did not succeed
  //     // return?
  //   } catch (e) {
  //     // print("Mahdi: initUniLinks: Error $e");
  //   }

  //   print("Mahdi: initUniLinks: 2");
  //   _sub = getUriLinksStream().listen((Uri uri) {
  //     String token = uri.toString().substring(
  //         uri.toString().indexOf("token=") + 6, uri.toString().length);

  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //       return ForgotPasswordWithKey(token);
  //     }));
  //     print("This is the token and nothing more. : $token");
  //   }, onError: (err) {
  //     print("Mahdi: initUniLinks: Error $err");
  //   });
  // }

  Widget page = LoginPage();
  @override
  Widget build(BuildContext context) {
    if (status == "userLogedIn") {
      page = LayoutExample();
    }
    return status == "checkingSharedPrefs"
        ? MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())))
        : MultiProvider(
            providers: [
              ChangeNotifierProvider<ResturantProvider>(
                  create: (_) => ResturantProvider()),
              ChangeNotifierProvider<AuthProvider>(
                  create: (_) => AuthProvider()),
              ChangeNotifierProvider<DashboardProvider>(
                  create: (_) => DashboardProvider()),
              ChangeNotifierProvider<CustomersProvider>(
                  create: (_) => CustomersProvider()),
              ChangeNotifierProvider<CategoryProvider>(
                  create: (_) => CategoryProvider()),
              ChangeNotifierProvider<CoupenProvider>(
                  create: (_) => CoupenProvider()),
              ChangeNotifierProvider<ContactProvider>(
                  create: (_) => ContactProvider()),
              ChangeNotifierProvider<NotificationProvider>(
                  create: (_) => NotificationProvider()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: restaurantTheme,
              home: page,
              routes: routes,
            ),
          );
  }
}
