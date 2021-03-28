class OrderItem {
  String foodId;
  String foodName;
  int quantity;
  List<AddOn> addOn;
  double price;
  String orderNote;
  OrderItem({
    this.foodId,
    this.foodName,
    this.quantity,
    this.addOn,
    this.price,
    this.orderNote,
  });
  factory OrderItem.fromJson(Map json) {
    List<AddOn> addOns = [];
    (json['addOn'] as List).forEach((element) {
      addOns.add(new AddOn.fromJson(element));
    });
    return OrderItem(
      foodId: json['foodId'],
      foodName: json['foodName'],
      quantity: json['quantity'],
      addOn: addOns,
      price: double.parse(json['price'].toString()),
      orderNote: json['orderNote'],
    );
  }
}

class AddOn {
  String name;
  int quantity;
  double price;
  AddOn({
    this.name,
    this.quantity,
    this.price,
  });
  factory AddOn.fromJson(json) {
    return AddOn(
      name: json['name'],
      quantity: json['quantity'],
      price: double.parse(json['price'].toString()),
    );
  }
}
