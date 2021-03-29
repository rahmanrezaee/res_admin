import 'package:restaurant/GlobleService/APIRequest.dart';
import 'package:restaurant/constants/api_path.dart';
import 'package:restaurant/modules/Authentication/screen/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:restaurant/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../validators/formFieldsValidators.dart';

class AuthProvider with ChangeNotifier {
  Future login(String username, String password, String fcm) async {
    try {
      print("Loging in");
      print({"email": username, "password": password});
      //sending data
      String url = "$baseUrl/restaurant/user/login";
      var res = await APIRequest().post(
        myUrl: url,
        myBody: {"email": username, "password": password, "fcmToken": fcm},
      );
      //getting user data
      var user = {
        'token': res.data['data']['token'],
        'expierDate': DateTime.now().add(Duration(days: 1)).toString(),
        'userId': res.data['data']['user']['_id'],
      };
      //saving user data to sharedpreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(json.encode(user));
      await prefs.setString('user', json.encode(user));
      //return message
      return {"status": true, "message": "logedIn"};
    } on DioError catch (e) {
      print(e.response);
      return e.response;
    }
  }

  // token
  // expierdate
  // userid
  Future forgotPassword(email) async {
    String url = "$baseUrl/customer/user/forgotpassword";
    print(email);
    try {
      var res = await APIRequest().post(
        myUrl: url,
        myBody: {"email": email},
      );
      print(res);
      return {'status': true};
    } on DioError catch (e) {
      print("error ${e.response}");
      return e.response.data;
    }
  }

  Future forgotPasswordWithKey(password, token) async {
    String url = "$baseUrl/restaurant/user/changepasswordwithKey";
    try {
      var res = await APIRequest().post(
        myUrl: url,
        myBody: {
          "token": token,
          "newPassword": password,
        },
      );
      print(res);
      return {'status': true};
    } on DioError catch (e) {
      return e.response.data;
    }
  }

  //Logout
  logOut(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    // Navigator.of(context).pushNamed(LoginPage.routeName);
  }

  get token {
    return checkLoginStatus();
  }

  Future<String> resturantId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') == null) {
      return '';
    } else {
      return json.decode(prefs.getString('user'))['userId'];
    }
  }

  Future checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') == null) {
      return '';
    } else {
      //Checking expiery date
      DateTime expireDate =
          DateTime.parse(json.decode(prefs.getString('user'))['expierDate']);
      if (DateTime.now().isAfter(expireDate.add(Duration(days: 1)))) {
        return refreshToken();
      } else {
        return json.decode(prefs.getString('user'))['token'];
      }
    }
  }

  refreshToken() {}
}
