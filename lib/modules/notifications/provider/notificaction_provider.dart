import 'package:restaurant/GlobleService/APIRequest.dart';
import 'package:restaurant/constants/api_path.dart';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:restaurant/modules/notifications/models/notification_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier {
  bool loadingMore;
  bool hasMoreItems;
  int maxItems;
  int page = 1;
  int lastPage;

  List<NotificationModel> notificatins;
  void setPage(int t) {
    this.page = t;
    notifyListeners();
  }

  void clearToNullList() {
    notificatins = null;
    hasMoreItems = null;
    loadingMore = null;
    maxItems = null;
    page = 1;
    notifyListeners();
  }

  fetchNotifications() async {
    try {
      final result = await APIRequest().get(
          myUrl: "$baseUrl/public/notification",
          token: await AuthProvider().token);

      print("result $result");

      maxItems = result.data['data']['totalDocs'];
      page = result.data['data']['page'];
      lastPage = result.data['data']['totalPages'];
      print("result $lastPage");

      if (page == lastPage) {
        hasMoreItems = false;
      } else {
        hasMoreItems = true;
      }

      List<NotificationModel> loadedProducts = [];

      (result.data['data']['docs'] as List).forEach((notify) {
        print("result $notify");
        loadedProducts.add(NotificationModel.fromJson(notify));
      });

      if (notificatins == null) {
        notificatins = [];
      }
      notificatins.addAll(loadedProducts);
      page++;

      notifyListeners();
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
    }
  }

  Future<bool> notificationChangeState(notificationId) async {
    try {
      final StringBuffer url =
          new StringBuffer("$baseUrl/public/notification/$notificationId");
      print(url.toString());

      final response = await APIRequest().post(
        myBody: {},
        myHeaders: {
          "token": await AuthProvider().token,
        },
        myUrl: url.toString(),
      );
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

  showLoadingBottom(bool state) {
    loadingMore = state;
    notifyListeners();
  }

  void setCountNotification(int i) {}
}
