import 'dart:async';

import 'package:restaurant/modules/Resturant/Models/TimeModel.dart';
import 'package:restaurant/modules/Resturant/Models/location.dart';

class ResturantModel {
  String resturantName;
  String avatar;
  String id;
  bool openForOrder;
  bool autoAcceptOrder;
  LocationModel location;
  TimeModel sunday = TimeModel();
  TimeModel monday = TimeModel();
  TimeModel tuesday = TimeModel();
  TimeModel wednesday = TimeModel();
  TimeModel thursday = TimeModel();
  TimeModel friday = TimeModel();
  TimeModel saturday = TimeModel();
  String email;
  String password;
  int activeOrder;

  ResturantModel();

  ResturantModel.toJson(tableData) {
    this.resturantName = tableData['restaurant']['username'];
    this.id = tableData['restaurant']['_id'];
    this.activeOrder = tableData['activeOrder'];
  }

  Map sendMap() {
    Map data = {
      // "avatar": this.avatar,
      "openForOrder": this.openForOrder,
      "autoAcceptOrder": this.autoAcceptOrder,
      // "location": {
      //   "type": "Point",
      //   "coordinates": [this.location.lat, this.location.log]
      // },
      "Sunday": {
        "time": [this.sunday.startTime, this.sunday.endTime]
      },
      "Monday": {
        "time": [this.monday.startTime, this.monday.endTime]
      },
      "Tuesday": {
        "time": [this.tuesday.startTime, this.tuesday.endTime]
      },
      "Wednesday": {
        "time": [this.wednesday.startTime, this.wednesday.endTime]
      },
      "Thursday": {
        "time": [this.thursday.startTime, this.thursday.endTime]
      },
      "Friday": {
        "time": [this.friday.startTime, this.friday.endTime]
      },
      "Saturday": {
        "time": [this.saturday.startTime, this.saturday.endTime]
      },
      "email": this.email,
    };
    print("paswwo ${this.password}");
    if (this.password != null && this.password != "") {
      data["password"] = this.password;
    }

    return data;
  }

  ResturantModel.toComplateJson(tableData) {
    this.location = LocationModel.toJson(tableData['location']);
    this.sunday = TimeModel.toJson(tableData['Sunday']);
    this.monday = TimeModel.toJson(tableData['Monday']);
    this.tuesday = TimeModel.toJson(tableData['Tuesday']);
    this.wednesday = TimeModel.toJson(tableData['Wednesday']);
    this.thursday = TimeModel.toJson(tableData['Thursday']);
    this.friday = TimeModel.toJson(tableData['Friday']);
    this.saturday = TimeModel.toJson(tableData['Saturday']);
    this.resturantName = tableData['username'];
    this.id = tableData['_id'];
    this.email = tableData['email'];
    this.avatar = tableData['avatar'];
    this.avatar = tableData['avatar'];
    this.autoAcceptOrder = tableData['autoAcceptOrder'];
    this.openForOrder = tableData['openForOrder'];
  }
}
