import '../../../GlobleService/APIRequest.dart';
import '../../../constants/api_path.dart';
import '../screen/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import '../../../themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../validators/formFieldsValidators.dart';

class AuthProvider with ChangeNotifier {
  Future login(String username, String password) async {
    try {
      print("Loging in");
      print({"email": username, "password": password});
      //sending data
      String url = "$baseUrl/restaurant/user/login";
      var res = await APIRequest().post(
        myUrl: url,
        myBody: {"email": username, "password": password},
      );
      print(res.data);
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
      print(e.response.data);
      return e.response.data;
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
      print(res.data);
      return {'status': true};
    } on DioError catch (e) {
      print(e);
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
