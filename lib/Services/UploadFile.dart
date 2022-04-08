import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:restaurant/constants/UrlConstants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

Future<Map?> uploadFile(File imageFile, String category, String token) async {
  final StringBuffer url = new StringBuffer(baseUrl + "/upload/single");
  Dio dio = new Dio();

  print(await MultipartFile.fromFile(imageFile.path));

  try {
    FormData formData = FormData.fromMap(
      {
        "uploadFile": await MultipartFile.fromFile(imageFile.path),
        "permission": true,
        "category": category
      },
    );

    if (token != null) {
      dio.options.headers = {
        "token": token,
      };
    }
    print(url.toString());

    var response = await dio.post(
      url.toString(),
      data: formData,
    );

    print("File Upload $formData");

    print("File UploadResponse: ${response.data}");

    if (response.data['status']) {
      // var respon = response.data["data"]["name"];
      return response.data['data'];
    } else {
      throw UploadException(response.data["message"]);
    }
  } on DioError catch (e) {
    print("errors");
    print("this is error bro: in saving bro: ${e.response}");
    // throw UploadException(e.response.data["message"]);
  }
}

Future<Map?> uploadFileAsset(Asset asset, String category, String token) async {
  final StringBuffer url = new StringBuffer(baseUrl + "/upload");
  Dio dio = new Dio();

  ByteData byteData = await asset.getByteData();
  List<int> imageData = byteData.buffer.asUint8List();

  try {
    FormData formData = FormData.fromMap(
      {"uploadFile": imageData, "token": token, "category": category},
    );

    if (token != null) {
      dio.options.headers = {
        "token": token,
      };
    }
    print(url.toString());

    var response = await dio.post(
      url.toString(),
      data: formData,
    );

    print("File Upload $formData");

    print("File UploadResponse: ${response.data}");

    if (response.data['status']) {
      // var respon = response.data["data"]["name"];
      return response.data['data'];
    } else {
      print(response.data["message"]);
    }
  } on DioError catch (e) {
    print("errors");
    print("this is error bro: in saving bro: ${e.response}");
    // throw UploadException(e.response.data["message"]);
  }
}

openImagePickerModal(context) {
  final flatButtonColor = Theme.of(context).primaryColor;

  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150.0,
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                alignment: Alignment.center,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                width: double.infinity,
                child: Text(
                  'Choose Image',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    textColor: flatButtonColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.camera),
                        Text('Camera'),
                      ],
                    ),
                    onPressed: () async {
                      File? file = await getImage(context, ImageSource.camera);
                      Navigator.pop(context, file);
                    },
                  ),
                  FlatButton(
                    textColor: flatButtonColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.images),
                        Text('Gallery'),
                      ],
                    ),
                    onPressed: () async {
                      File? file = await getImage(context, ImageSource.gallery);
                      Navigator.pop(context, file);
                    },
                  ),
                ],
              )
            ],
          ),
        );
      });
}

Future<File?> getImage(context, ImageSource source) async {
  File imageFile = await ImagePicker.pickImage(
    source: source,
    imageQuality: 85,
  );

  if (imageFile != null) {
    return await _cropImage(context, imageFile);
  } else {
    return null;
  }
}

// try {
//   var result = await Auth().uploadFile(_imageFile, "profile");
//   user.profile = result['uriPath'];
// } on UploadException catch (e) {
//   _scaffoldKey.currentState.showSnackBar(showSnackbar(
//       text: e.cause, icon: Icon(Icons.error), color: Colors.red));
// }

// setState(() {
//   _isUploadingImage = false;
// });

Future<File?> _cropImage(context, _imageFile) async {
  File ? croppedFile = await ImageCropper().cropImage(
      sourcePath: _imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
            ]
          : [
              CropAspectRatioPreset.square,
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Edit Image',
          toolbarColor: Theme.of(context).primaryColor,
          cropFrameColor: Theme.of(context).primaryColor,
          statusBarColor: Theme.of(context).primaryColor,
          activeControlsWidgetColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Edit Image',
      ));
  if (croppedFile != null) {
    return _imageFile = croppedFile;
  } else {
    return null;
  }
}

class UploadException implements Exception {
  String cause;

  UploadException(this.cause);
}
