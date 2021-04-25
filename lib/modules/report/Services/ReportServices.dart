import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/GlobleService/APIRequest.dart';
import 'package:restaurant/constants/UrlConstants.dart';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';

Future getReport(
    {fromDate, toDate, type, coupenCode, @required AuthProvider auth}) async {
  try {
    String url =
        "$baseUrl/restaurant/report?type=$type${coupenCode != null && coupenCode != "" ? "&couponCode=" + coupenCode : ""}${fromDate != null ? "&fromDate=" + fromDate : ""}${toDate != null ? "&toDate=" + toDate : ""}";
    print("url $url");
    final result = await APIRequest().get(myUrl: url, token: auth.token);

    final extractedData = result.data["data"];
    return extractedData;
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
  }
}

Future getSendReportEmil(
    {fromDate, toDate, coupenCode, @required AuthProvider auth}) async {
  try {
    String url =
        "$baseUrl/restaurant/report/email-report-orders?${coupenCode != null && coupenCode != "" ? "&couponCode=" + coupenCode : ""}${fromDate != null ? "&fromDate=" + fromDate : ""}${toDate != null ? "&toDate=" + toDate : ""}";
    print("url $url");
    Map data = {};

    if (fromDate != null) {
      data = {
        "fromDate": fromDate,
      };
    }
    if (toDate != null) {
      data = {
        "toDate": toDate,
      };
    }
    if (coupenCode != null) {
      data = {
        "couponCode": coupenCode,
      };
    }

    print(data);
    final result = await APIRequest()
        .post(myUrl: url, myHeaders: {"token": auth.token}, myBody: data);

    print("result $result");

    final extractedData = result.data["data"];
    return extractedData;
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
  }
}

Future getSendReportEmailEarnings(
    {fromDate, toDate, @required AuthProvider auth}) async {
  try {
    String url =
        "$baseUrl/restaurant/report/email-report-earnings?${fromDate != null ? "&fromDate=" + fromDate : ""}${toDate != null ? "&toDate=" + toDate : ""}";
    print("url $url");
    Map data = {};

    if (fromDate != null) {
      data = {
        "fromDate": fromDate,
      };
    }
    if (toDate != null) {
      data = {
        "toDate": toDate,
      };
    }

    print(data);
    final result = await APIRequest()
        .post(myUrl: url, myHeaders: {"token": auth.token}, myBody: data);

    print("result $result");

    final extractedData = result.data["data"];
    return extractedData;
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
  }
}
