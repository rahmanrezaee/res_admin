import 'package:restaurant/GlobleService/APIRequest.dart';
import 'package:restaurant/constants/UrlConstants.dart';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:restaurant/modules/orders/Models/OrderModels.dart';
import 'package:dio/dio.dart';

class OrderServices {
  Future<List<OrderModels>> getSingleOrder({
    state,
  }) async {
    List<OrderModels> listOrder;
    try {
      String url = "$baseUrl/restaurant/order?status=$state";

      final result =
          await APIRequest().get(myUrl: url, token: await AuthProvider().token);

      print("result $result");

      final extractedData = result.data["data"]['docs'];

      if (extractedData == null) {
        listOrder = [];
        return listOrder;
      }

      final List<OrderModels> loadedOrder = [];

      extractedData.forEach((tableData) {
        loadedOrder.add(OrderModels.toJson(tableData));
      });

      listOrder = loadedOrder;

      return loadedOrder;
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
    }
  }

  Future<bool> pickup(orderId, statue) async {
    try {
      String url = "$baseUrl/admin/order/$orderId";

      final result = await APIRequest().post(
          myUrl: url,
          myHeaders: {"token": await AuthProvider().token},
          myBody: {"status": statue});

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

  Future<bool> updatepickupDate(orderId, pickUpTime) async {
    try {
      String url = "$baseUrl/admin/order/pickuptime/$orderId";

      final result = await APIRequest().post(
          myUrl: url,
          myHeaders: {"token": await AuthProvider().token},
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
