import 'package:restaurant/GlobleService/APIRequest.dart';
import 'package:restaurant/constants/UrlConstants.dart';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:restaurant/modules/contactUs/model/contact_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ContactProvider with ChangeNotifier {
  List<ContactModel> contacts;
  List<ContactModel> get getContacts => this.contacts;

  Future<bool> fetchContacts() async {
    try {
      String url = "$baseUrl/admin/contact";

      print("URl $url");

      final result =
          await APIRequest().get(myUrl: url, token: await AuthProvider().token);

      print("result $result");

      final extractedData = result.data["data"];

      if (extractedData == null) {
        contacts = [];
        return false;
      }
      print("result $result");
      final List<ContactModel> loadedProducts = [];

      extractedData.forEach((tableData) {
        loadedProducts.add(ContactModel.fromJson(tableData));
      });

      contacts = loadedProducts;

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
