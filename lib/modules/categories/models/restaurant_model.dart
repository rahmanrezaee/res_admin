class RestaurantModel {
  int activeOrder;
  Map restaurant = {
    "_id": '603f313fd0c6141040de8c89',
    "username": "Resraurant name"
  };
  RestaurantModel({
    this.activeOrder,
    this.restaurant,
  });

  factory RestaurantModel.fromJson(json) {
    return new RestaurantModel(
      activeOrder: json["activeOrder"],
      restaurant: json["restaurant"],
    );
  }
}
