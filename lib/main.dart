// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/themes/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/Authentication/providers/auth_provider.dart';
import 'modules/Authentication/screen/login_page.dart';
import 'modules/Resturant/statement/resturant_provider.dart';
import 'modules/categories/provider/categories_provider.dart';
import 'modules/contactUs/providers/contact_provider.dart';
import 'modules/dashboard/provider/dashboard_provider.dart';
import 'modules/drawer/drawer.dart';
import 'modules/notifications/provider/notificaction_provider.dart';
import 'modules/orders/orders_page_notification.dart';
import 'routes.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
//

bool isBackgroudRunning = false;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  isBackgroudRunning = true;
  await Firebase.initializeApp();

  print(
      'Handling a background message ${message.messageId} ${isBackgroudRunning}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
  showBadge: true,
  enableLights: true,
  enableVibration: true,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

/// Entry point for the example application.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ResturantProvider>(
          update: (context, auth, __) => ResturantProvider(auth),
          create: (context) => ResturantProvider(null),
        ),
        ChangeNotifierProxyProvider<AuthProvider, DashboardProvider>(
          update: (context, auth, __) => DashboardProvider(auth),
          create: (context) => DashboardProvider(null),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CategoryProvider>(
          update: (context, auth, __) => CategoryProvider(auth),
          create: (context) => CategoryProvider(null),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ContactProvider>(
          update: (context, auth, __) => ContactProvider(auth),
          create: (context) => ContactProvider(null),
        ),
        ChangeNotifierProxyProvider<AuthProvider, NotificationProvider>(
          update: (context, auth, __) => NotificationProvider(auth),
          create: (context) => NotificationProvider(null),
        ),
      ],
      child: Consumer<AuthProvider>(builder: (context, snapshot, b) {
        return ConnectivityAppWrapper(
          app: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Manager App',
            theme: restaurantTheme,
            home: ConnectivityWidgetWrapper(
              stacked: true,
              height: 30,
              message: "Connecting...",
              child: snapshot.token != null
                  ? Application()
                  : FutureBuilder(
                      future: snapshot.autoLogin(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return LoginPage();
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
            ),
            routes: routes,
          ),
        );
      }),
    );
  }
}

/// Renders the example application.
class Application extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Application();
}

class _Application extends State<Application> {
  String status = 'checkingSharedPrefs';

  Future selectNotification(String payload) async {
    print("payload $payload");
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => OrdersPageNotification()));
  }

  getPrefs() async {
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
  }

  @override
  void initState() {
    super.initState();
    getPrefs();

    print("firebase message is setuping...");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      // print("found"); /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');
      final InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: selectNotification);

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'launch_background',
              ),
            ));
      }

      if (notification != null) {
        NotificationProvider notificationProvider =
            Provider.of<NotificationProvider>(context, listen: false);

        if (notificationProvider.notificatins == null)
          await notificationProvider.fetchNotifications();

        notificationProvider
            .setCountNotification(notificationProvider.maxItems + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutExample();
  }
}
