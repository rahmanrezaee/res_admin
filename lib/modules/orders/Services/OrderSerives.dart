import 'package:flutter/material.dart';
import 'package:restaurant/GlobleService/APIRequest.dart';
import 'package:restaurant/constants/UrlConstants.dart';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:restaurant/modules/orders/Models/OrderModels.dart';
import 'package:dio/dio.dart';

class OrderServices {
  Future<Map?> getSingleOrder(
      {state, required AuthProvider auth, int?  page}) async {
    List<OrderModels> ?listOrder;
    try {
      String url = "$baseUrl/restaurant/order?status=$state";

      final result = await APIRequest().get(myUrl: url, token: auth.token);

      final extractedData = result.data["data"]['docs'];

      if (extractedData == null) {
        listOrder = [];

        throw Exception("error in Fetch Data");
      }

      final List<OrderModels> loadedOrder = [];
      print("extractedData $extractedData");
      int i = 0;
      extractedData.forEach((tableData) {
        i++;

        print("elements $i");
        loadedOrder.add(OrderModels.toJson(tableData));
      });

      listOrder = loadedOrder;

      return {"orders": listOrder, "total": result.data["data"]['totalDocs']};
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
    }
  }

  Future<bool?> pickup(orderId, statue, AuthProvider auth) async {
    try {
      String url = "$baseUrl/admin/order/$orderId";

      final result = await APIRequest().post(
          myUrl: url,
          myHeaders: {"token": auth.token},
          myBody: {"status": statue});

      print("result $result $result");
      return true;
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
    }
  }

  Future<bool?> updatepickupDate(orderId, pickUpTime, AuthProvider auth) async {
    try {
      String url = "$baseUrl/admin/order/pickuptime/$orderId";

      final result = await APIRequest().post(
          myUrl: url,
          myHeaders: {"token": auth.token},
          myBody: {"pickUpTime": pickUpTime});

      print("result $result");
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
