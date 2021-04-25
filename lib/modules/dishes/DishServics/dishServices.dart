import 'package:restaurant/GlobleService/APIRequest.dart';
import 'package:restaurant/constants/UrlConstants.dart';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:restaurant/modules/dishes/Models/dishModels.dart';
import 'package:dio/dio.dart';

Future<DishModel> getSingleDish(id, AuthProvider auth) async {
  try {
    String url = "$baseUrl/admin/food/view/$id";

    final result = await APIRequest().get(myUrl: url, token: auth.token);

    print("result $result");

    final extractedData = result.data["data"];

    if (extractedData == null) {
      return null;
    }

    return Future.value(DishModel.toComplateJson(extractedData));
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
  }
}

Future<List<DishModel>> getFootListWithoutPro(catId, AuthProvider auth) async {
  try {
    String url = "$baseUrl/restaurant/category/$catId";

    final result = await APIRequest().get(myUrl: url, token: auth.token);

    print("result $result");

    final extractedData = result.data["data"];

    List<DishModel> loadedProducts = [];

    extractedData.forEach((tableData) {
      loadedProducts.add(DishModel.toCatJson(tableData));
    });

    return loadedProducts;
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
  }
}

Future addDishService(data, AuthProvider auth) async {
  print("da $data");
  try {
    final StringBuffer url = new StringBuffer("$baseUrl/admin/food");
    print(url.toString());

    final response = await APIRequest().post(
      myBody: data,
      myHeaders: {
        "token": auth.token,
      },
      myUrl: url.toString(),
    );

    final extractedData = response.data;
    print("franch data 1 $extractedData ");
    return {'status': true, 'message': 'Dish added successfuly'};
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
    return e.response.data;
  }
}

Future editDishService(data, id, AuthProvider auth) async {
  print("da $data");
  try {
    final StringBuffer url = new StringBuffer("$baseUrl/admin/food/$id");
    print(url.toString());

    final response = await APIRequest().put(
      myBody: data,
      myHeaders: {
        "token": auth.token,
      },
      myUrl: url.toString(),
    );

    final extractedData = response.data;
    print("franch data 1 $extractedData ");

    return {'status': true, 'message': 'Dish added successfuly'};
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
    return e.response;
  }
}

Future deleteDish(id, AuthProvider auth) async {
  try {
    //getting token

    String url = "$baseUrl/restaurant/food/$id";
    var res = await APIRequest()
        .delete(myUrl: url, myBody: null, myHeaders: {'token': auth.token});
    print("delete of dish ${res.data}");
    return res.data;
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
    return e.response.data;
  }
}

Future<bool> changeVisiablity(foodId, vis, AuthProvider auth) async {
  try {
    String url = "$baseUrl/admin/food/changevisibility/$foodId";

    final result = await APIRequest().post(
        myUrl: url,
        myHeaders: {"token": auth.token},
        myBody: {"visibility": vis});

    print("result $result");

    return result.data['status'];
  } on DioError catch (e) {
    print("error In Response");
    print(e.response);
    print(e.error);
    print(e.request);
    print(e.type);
  }
}
