import 'package:flutter/cupertino.dart';
import 'package:restaurant/modules/Authentication/screen/login_page.dart';
import 'package:restaurant/modules/Privacy&Policy.dart';
import 'package:restaurant/modules/addNewDish/addNewDish_page.dart';
import 'package:restaurant/modules/drawer/drawer.dart';
import 'package:restaurant/modules/Authentication/screen/forgotPassword.dart';
import 'package:restaurant/modules/term&condition_page.dart';

var routes = <String, WidgetBuilder>{
  //add routes here
  ForgotPassword.routeName: (context) => ForgotPassword(),
  LayoutExample.routeName: (context) => LayoutExample(),
  TermCondition.routeName: (context) => TermCondition(),
  PrivacyPolicy.routeName: (context) => PrivacyPolicy(),
  LoginPage.routeName: (context) => LoginPage(),
  // AddNewDish.routeName: (context) => AddNewDish(),
};
