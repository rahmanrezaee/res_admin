import 'dart:async';

class CouponModel {
  String id;
  String name;
  String code;
  String resturant;
  String type;
  double mount;

  CouponModel();
  CouponModel.toJson(tableData) {
    this.id = tableData['_id'];
    this.name = tableData['name'];
    this.code = tableData['code'];
  }
  Map sendMap() {
    Map data = {
      "code": this.code,
      "percentage": this.mount,
      "name": this.name,
      "type": this.type,
      "validRestaurant": [this.resturant],
    };

    return data;
  }

  CouponModel.toComplateJson(extractedData) {
    this.id = extractedData['_id'];
    this.name = extractedData['name'];
    this.code = extractedData['code'];
    this.resturant = extractedData['validRestaurant'][0]['_id'];
    this.type = extractedData['type'];
    this.mount = double.parse("${extractedData['percentage']}");
  }
}
