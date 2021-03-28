import 'dart:async';
import '../screen/forgotPasswordWithKey.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
StreamSubscription _sub;
Future<Null> initUniLinks(context) async {
  try {
    String initialUri = await getInitialLink();
    String uri = initialUri.toString();
    String token = uri
        .toString()
        .substring(uri.toString().indexOf("token=") + 6, uri.toString().length);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ForgotPasswordWithKey(token);
    }));
    print("This is the token and nothing more. : $token");
  } on FormatException {
    print("Error Accured");
  } catch (e) {
    print("Error Catched $e");
  }
  print("Mahdi: initUniLinks: 2");
}