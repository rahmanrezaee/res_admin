class LocationModel {
  String type;
  double lat;
  double log;

  LocationModel();
  LocationModel.toJson(data) {
    this.type = data['type'];
    this.lat = data['coordinates'][0];
    this.log = data['coordinates'][1];
  }
}
