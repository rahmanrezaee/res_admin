import 'package:restaurant/GlobleService/APIRequest.dart';
import 'package:restaurant/constants/UrlConstants.dart';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:restaurant/modules/Resturant/Models/Resturant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ResturantProvider with ChangeNotifier {
  List<ResturantModel> listResturant;
  AuthProvider auth;
  ResturantProvider(this.auth);

  Future<bool> deleteResturant(resturantId) async {
    try {
      //getting token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = json.decode(prefs.getString("user"))['token'];
      //getting data
      String url = "$baseUrl/admin/restaurant/$resturantId";
      var res = await APIRequest()
          .delete(myUrl: url, myBody: null, myHeaders: {'token': token});

      listResturant = null;
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

  Future<ResturantModel> getSingleResturant(id) async {
    try {
      String url = "$baseUrl/admin/restaurant/profile/$id";

      final result = await APIRequest().get(myUrl: url, token: auth.token);

      print("result $result");

      final extractedData = result.data["data"];

      if (extractedData == null) {
        return null;
      }

      return Future.value(ResturantModel.toComplateJson(extractedData));
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
    }
  }

  Future<bool> getResturantList() async {
    try {
      String url = "$baseUrl/admin/restaurant";

      final result = await APIRequest().get(myUrl: url, token: auth.token);

      print("result $result");

      final extractedData = result.data["data"];

      if (extractedData == null) {
        listResturant = [];
        return false;
      }

      final List<ResturantModel> loadedProducts = [];

      extractedData.forEach((tableData) {
        loadedProducts.add(ResturantModel.toJson(tableData));
      });

      listResturant = loadedProducts;

      print(listResturant);

      notifyListeners();

      return true;
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
    }
  }

  Future<List<Map<String, String>>> getResturantListWithoutPro() async {
    try {
      String url = "$baseUrl/admin/restaurant";

      final result = await APIRequest().get(myUrl: url, token: auth.token);

      print("result $result");

      final extractedData = result.data["data"];

      List<Map<String, String>> loadedProducts = [];

      extractedData.forEach((tableData) {
        loadedProducts.add(
          {
            "display": tableData['restaurant']['username'],
            "value": tableData['restaurant']['_id']
          },
        );
      });

      return loadedProducts;
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
    }
  }

  Future<bool> addResturant(data) async {
    print("da $data");
    try {
      final StringBuffer url = new StringBuffer("$baseUrl/admin/restaurant");
      print(url.toString());

      final response = await APIRequest().post(
        myBody: data,
        myHeaders: {
          "token": auth.token,
        },
        myUrl: url.toString(),
      );

      final extractedData = response.data["data"];
      print("franch data 1 $extractedData ");

      listResturant = null;
      // listResturant.add(ResturantModel.toJson(extractedData));

      notifyListeners();
      return true;
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
    }
  }

  Future<bool> editResturant(data, id) async {
    print("da $data");
    try {
      final StringBuffer url =
          new StringBuffer("$baseUrl/admin/restaurant/profile/$id");
      print(url.toString());

      final response = await APIRequest().put(
        myBody: data,
        myHeaders: {
          "token": auth.token,
        },
        myUrl: url.toString(),
      );

      final extractedData = response.data["data"];
      print("franch data 1 $extractedData ");

      listResturant = null;

      notifyListeners();
      return true;
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
    }
  }
}
