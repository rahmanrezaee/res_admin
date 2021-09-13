class ImageModel {
  String url;
  String id;

  ImageModel.toJson(element) {
    this.id = element['_id'];
    this.url = element['uriPath'];
  }
}
