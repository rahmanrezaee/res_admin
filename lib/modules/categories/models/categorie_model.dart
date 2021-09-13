class CategoryModel {
  String id;
  String categoryName;
  int foodNumber;
  CategoryModel({
    this.id,
    this.categoryName,
    this.foodNumber,
  });

  factory CategoryModel.fromJson(json) {
    return new CategoryModel(
      id: json['_id'],
      categoryName: json['categoryName'],
      foodNumber: json['foodNumber'],
    );
  }
}
