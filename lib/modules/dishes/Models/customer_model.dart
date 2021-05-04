import 'dart:developer';

// @JsonSerializable(explicitToJson: true)
class Customer {
  String id;
  int activeOrders;
  String username;
  dynamic avatar;
  String email;
  int totalOrder;
  Customer({
    this.id,
    this.username,
    this.activeOrders,
    this.avatar,
    this.email,
    this.totalOrder,
  });
  factory Customer.fromJson(json) {
    log("ID: ${json}");
    try {
      return Customer(
        id: json["user"]['_id'],
        username: json["user"]['username'],
        activeOrders: json['activeOrders'],
        // avatar: json['avatar'],
        // email: json['email'],
        totalOrder: json['totalOrder'],
      );
    } catch (e) {
      log("error $e");
    }
  }

  Customer.fromComplateJson(json) {
    log("ID: ${json}");
    try {
      this.id = json["userData"]['_id'];
      username = json["userData"]['username'];

      avatar = json["userData"]['avatar'];
      email = json["userData"]['email'];
    } catch (e) {
      log("error $e");
    }
  }

  Customer.fromDishJson(json) {
    log("ID: ${json}");
    try {
      id = json['_id'];
      username = json['username'];
      avatar = json['avatar'];
    } catch (e) {
      log("error $e");
    }
  }
}
