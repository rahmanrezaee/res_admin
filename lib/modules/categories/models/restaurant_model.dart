class RestaurantModel {
  int ?activeOrder;
  Map ?restaurant = {
   
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
