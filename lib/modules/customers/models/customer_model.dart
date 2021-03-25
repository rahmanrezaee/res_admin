part 'customer_model.g.dart';

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
    print("ID: ${json['id']}");
    return Customer(
      id: json['id'],
      username: json['username'],
      activeOrders: json['activeOrders'],
      avatar: json['avatar'],
      email: json['email'],
      totalOrder: json['totalOrder'],
    );
  }
  // factory Customer.fromJson(Map json) => _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
