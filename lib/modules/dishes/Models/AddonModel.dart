class AddonItems {
  String ?name;
  int quantity = 1;
  double ?price;

  AddonItems();
  AddonItems.toJson(element) {
    this.name = element['name'];
    this.quantity = element['quantity'] ?? 1;
    this.price = double.parse("${element['price']}");
  }
}
