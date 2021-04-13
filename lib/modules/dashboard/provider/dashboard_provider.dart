import 'package:dio/dio.dart';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/GlobleService/APIRequest.dart';
import 'package:restaurant/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DashboardProvider with ChangeNotifier {
  var _dashboardData;
  AuthProvider auth;

  DashboardProvider(this.auth);
  get getDashData => _dashboardData;
  bool openForOrder;
  bool autoAcceptOrder;

  bool isloading = false;

  fetchDashData() async {
    // if (token == '') {
    String url = "$baseUrl/restaurant/dashboard";
    var res = await APIRequest().get(myUrl: url, token: auth.token);
    this._dashboardData = res.data['data'];

    openForOrder = _dashboardData['restaurant']['openForOrder'];
    autoAcceptOrder = _dashboardData['restaurant']['autoAcceptOrder'];
    print(_dashboardData);
    notifyListeners();
    // }
  }

  Future<bool> resturantChangeStateOpenForOrder(resturantId, bool state) async {
    try {
      final StringBuffer url =
          new StringBuffer("$baseUrl/restaurant/user/profile/$resturantId");
      print(url.toString());

      final response = await APIRequest().put(
        myBody: {"openForOrder": state},
        myHeaders: {
          "token": auth.token,
        },
        myUrl: url.toString(),
      );

      openForOrder = state;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
      return false;
    }
  }

  Future<bool> resturantChangeStateAutoAcceptOrder(
      resturantId, bool state) async {
    try {
      final StringBuffer url =
          new StringBuffer("$baseUrl/restaurant/user/profile/$resturantId");
      print(url.toString());

      final response = await APIRequest().put(
        myBody: {"autoAcceptOrder": state},
        myHeaders: {
          "token": auth.token,
        },
        myUrl: url.toString(),
      );

      autoAcceptOrder = state;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
      return false;
    }
  }
}
