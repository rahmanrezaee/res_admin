// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:restaurant/modules/Authentication/screen/forgotPasswordWithKey.dart';
// import 'package:uni_links/uni_links.dart';

// StreamSubscription _sub;
// bool first = true;
// Future<Null> initUniLinks(context) async {
//   // Uri parsing may fail, so we use a try/catch FormatException.
//   try {
//     if (first == true) {
//       String initialUri = await getInitialLink();
//       String uri = initialUri.toString();
//       String token = uri.toString().substring(
//           uri.toString().indexOf("token=") + 6, uri.toString().length);
//       Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//         return ForgotPasswordWithKey(token);
//       }));
//       print("This is the token and nothing more: $token");
//       first = false;
//     }
//   } on FormatException {
//     print("Error Accured");
//     // Handle exception by warning the user their action did not succeed
//     // return?
//   } catch (e) {
//     print("Error Catched $e");
//     // print("Mahdi: initUniLinks: Error $e");
//   }
//   print("Mahdi: initUniLinks: 2");
//   _sub = getUriLinksStream().listen((Uri uri) {
//     String token = uri
//         .toString()
//         .substring(uri.toString().indexOf("token=") + 6, uri.toString().length);

//     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//       return ForgotPasswordWithKey(token);
//     }));
//     print("This is the token and nothing more: $token");
//   }, onError: (err) {
//     print("Mahdi: initUniLinks: Error $err");
//   });
// }

// onDisposPage() {
//   _sub.cancel();
// }
