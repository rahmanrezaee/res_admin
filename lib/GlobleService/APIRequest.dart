import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class APIRequest {
  Dio dio = new Dio();

  Future get({
    @required String myUrl,
    token,
  }) {
    try {
      if (token == null) {
        return dio.get(myUrl);
      } else {
        return dio.get(myUrl,
            options: new Options(headers: {'token': '$token'}));
      }
    } on DioError catch (e) {
      print("error In Response");
      print(e.response);
      print(e.error);
      print(e.request);
      print(e.type);
    }
  }

  Future post({
    @required String myUrl,
    @required myBody,
    Map<String, dynamic> myHeaders,
  }) {
    if (myHeaders != null) {
      dio.options.headers = myHeaders;
    }
    return dio.post(myUrl, data: myBody);
  }

  Future put({
    @required String myUrl,
    @required dynamic myBody,
    @required Map<String, dynamic> myHeaders,
  }) {
    dio.options.headers = myHeaders;
    return dio.put(myUrl, data: myBody);
  }

  Future delete({
    @required String myUrl,
    @required dynamic myBody,
    @required Map<String, dynamic> myHeaders,
  }) {
    dio.options.headers = myHeaders;
    return dio.delete(myUrl, data: myBody);
  }
}
