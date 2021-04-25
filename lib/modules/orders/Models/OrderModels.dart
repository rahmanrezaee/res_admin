import 'dart:developer';

import 'package:restaurant/modules/dishes/Models/dishModels.dart';

class OrderModels {
  String status;
  String id;
  String restaurantId;
  List<DishModel> items = [];
  int totalItems;
  Map user;
  double totalPrice;
  double grandTotal;
  double restaurantCharges;
  String cardName;
  String date;
  String timePicker;

  OrderModels.toJson(Map tableData) {
    try {
      print("order model $tableData");
      this.status = tableData['status'] ?? "";
      this.id = tableData['_id'] ?? "";
      this.restaurantId = tableData['restaurantId'] ?? "";
      this.totalItems = tableData['totalItems'] ?? 0;
      this.date = tableData['createdAt'] ?? "";
      this.totalPrice = double.parse("${tableData['totalPrice']}") ?? 0;
      this.user = tableData['userId'] ?? {"_id": "", "username": ""};
      this.restaurantCharges =
          double.parse("${tableData['restaurantCharges']}") ?? 0;
      this.grandTotal = double.parse("${tableData['grandTotal']}") ?? 0;
      this.cardName = tableData['cardName'] ?? "";
      this.timePicker = tableData['pickUpTime'] ?? "00:00";

      List food = tableData['items'];
      if (food != null && food.isNotEmpty) {
        food.forEach((element) {
          items.add(DishModel.toJson(element));
        });
      }
      log("done until end");
    } catch (e) {
      print("Hey Rahman: $e");
    }
  }
}
