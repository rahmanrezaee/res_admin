import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIRequest {
  Dio dio = new Dio();

  Future get({
    @required String myUrl,
    token,
  }) {
    try {
      if (token == null) {
        return dio.get(myUrl);
      } else {
        Future<Response> res =
            dio.get(myUrl, options: new Options(headers: {'token': '$token'}));
        res.then((value) async {
          //saving user data to sharedpreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();

          log("token header ${value.headers['token'][0]}");
          var user = {
            'token': value.headers['token'][0],
            'expierDate': DateTime.now().add(Duration(days: 1)).toString(),
            "userId": await AuthProvider().userId,
            "fcmToken": await AuthProvider().fcmToken,
          };

          print(json.encode(user));

          await prefs.setString('user', json.encode(user));
        });
        return res;
      }
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
    }
  }

  Future post({
    @required String myUrl,
    @required myBody,
    Map<String, dynamic> myHeaders,
  }) {
    if (myHeaders != null) {
      dio.options.headers = myHeaders;

      Future<Response> res = dio.post(myUrl, data: myBody);
      res.then((value) async {
        log("token header $value");
        var user = {
          'token': value.headers['token'][0],
          'expierDate': DateTime.now().add(Duration(days: 1)).toString(),
          "userId": await AuthProvider().userId,
          "fcmToken": await AuthProvider().fcmToken,
        };
        //saving user data to sharedpreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print(json.encode(user));

        await prefs.setString('user', json.encode(user));
      });
      return res;
    } else {
      return dio.post(myUrl, data: myBody);
    }
  }

  Future put({
    @required String myUrl,
    @required dynamic myBody,
    @required Map<String, dynamic> myHeaders,
  }) {
    dio.options.headers = myHeaders;
    Future<Response> res = dio.put(myUrl, data: myBody);
    res.then((value) async {
      var user = {
        'token': value.headers['token'][0],
        'expierDate': DateTime.now().add(Duration(days: 1)).toString(),
        "userId": await AuthProvider().userId,
        "fcmToken": await AuthProvider().fcmToken,
      };
      //saving user data to sharedpreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(json.encode(user));

      await prefs.setString('user', json.encode(user));
    });
    return res;
  }

  Future delete({
    @required String myUrl,
    @required dynamic myBody,
    @required Map<String, dynamic> myHeaders,
  }) {
    dio.options.headers = myHeaders;
    Future<Response> res = dio.delete(myUrl, data: myBody);

    res.then((value) async {
      var user = {
        'token': value.headers['token'][0],
        'expierDate': DateTime.now().add(Duration(days: 1)).toString(),
        "userId": await AuthProvider().userId,
        "fcmToken": await AuthProvider().fcmToken,
      };
      //saving user data to sharedpreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(json.encode(user));

      await prefs.setString('user', json.encode(user));
    });
    return res;
  }
}
