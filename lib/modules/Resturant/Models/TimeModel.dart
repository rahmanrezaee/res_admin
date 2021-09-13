class TimeModel {
  String startTime;
  String endTime;
  TimeModel();

  TimeModel.toJson(data) {
    this.startTime = data['time'][0];
    this.endTime = data['time'][1];
  }
}
