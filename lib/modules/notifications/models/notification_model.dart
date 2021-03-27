class NotificationModel {
  String status;
  String id;
  String title;
  String image;
  String body;
  String createdAt;
  NotificationModel({
    this.status,
    this.id,
    this.title,
    this.image,
    this.body,
    this.createdAt,
  });

  factory NotificationModel.fromJson(json) {
    return NotificationModel(
      status: json['status'],
      id: json['_id'],
      title: json['title'],
      image: json['image'],
      body: json['body'],
      createdAt: json['createdAt'],
    );
  }
}
