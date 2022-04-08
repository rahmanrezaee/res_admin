import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:restaurant/modules/categories/models/categorie_model.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/GlobleService/APIRequest.dart';
import 'package:restaurant/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/restaurant_model.dart';

class CategoryProvider with ChangeNotifier {
  ///cat List
  List<CategoryModel> ?_categories;
  AuthProvider ?auth;
  CategoryProvider(this.auth);
  get getCategories => _categories;

  setCategoryToNull() {
    _categories = null;
    notifyListeners();
  }

  fetchCategories() async {
    String url = "$baseUrl/restaurant/category";
    var res = await APIRequest().get(
      myUrl: url,
      token: auth!.token,
    );
    this._categories = [];
    (res.data['data'] as List).forEach((category) {
      print("thsi is the single cat: $category");
      this._categories!.add(new CategoryModel.fromJson(category));
    });
    notifyListeners();
  }

  //add Category
  Future addNewCategory(String resId, String newCategory) async {
    try {
      String url = "$baseUrl/restaurant/category";
      var res = await APIRequest().post(
        myUrl: url,
        myBody: {"restaurantId": resId, "categoryName": newCategory},
        myHeaders: {
          "token": auth!.token,
        },
      );

      this._categories = null;
      notifyListeners();
      return res.data;
    } on DioError catch (e) {
      print("error ${e.response}");
    }
  }

  //Edit category
  Future<Map> editCategory(catId, category) async {
    String url = "$baseUrl/public/category/$catId";
    var res = await APIRequest().put(
      myUrl: url,
      myBody: {
        "categoryName": category,
      },
      myHeaders: {
        "token": auth!.token,
      },
    );
    this._categories = null;
    print(res.data);
    notifyListeners();
    return res.data;
  }

  deleteCategoy(categryId) async {
    //getting token

    //getting data
    String url = "$baseUrl/public/category/$categryId";
    var res = await APIRequest().delete(myUrl: url, myBody: null, myHeaders: {
      'token': auth!.token,
    });
    this._categories = null;
    notifyListeners();
    return res.data;
  }
}
