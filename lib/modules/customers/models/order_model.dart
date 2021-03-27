import './orderItem_model.dart';

class OrderModel {
  String id;
  String customerName;
  String status;
  String restaurantId;
  String userId;
  int totalItems;
  List<OrderItem> items;
  double totalPrice;
  int restaurantCharges;
  int grandTotal;
  String cardName;
  String createdAt;
  String updatedAt;
  String pickUpTime;
  OrderModel({
    this.id,
    this.status,
    this.customerName,
    this.restaurantId,
    this.userId,
    this.totalItems,
    this.items,
    this.totalPrice,
    this.restaurantCharges,
    this.grandTotal,
    this.cardName,
    this.createdAt,
    this.updatedAt,
    this.pickUpTime,
  });

  factory OrderModel.fromJson(json) {
    List<OrderItem> items = [];
    (json['items'] as List).forEach((order) {
      items.add(OrderItem.fromJson(order));
    });

    return new OrderModel(
      id: json['_id'],
      status: json['status'],
      restaurantId: json['restaurantId'],
      userId: json['userId'],
      totalItems: json['totalItems'],
      items: items,
      totalPrice: double.parse(json['totalPrice'].toString()),
      restaurantCharges: json['restaurantCharges'],
      grandTotal: json['grandTotal'],
      cardName: json['cardName'],
      createdAt: json['createdAt'],
      customerName: json['customerName'],
      updatedAt: json['updatedAt'],
      pickUpTime: json['pickUpTime'],
    );
  }
}
