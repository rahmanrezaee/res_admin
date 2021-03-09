import 'package:flutter/cupertino.dart';
import 'package:restaurant/modules/Privacy&Policy.dart';
import 'package:restaurant/modules/addNewDish/addNewDish_page.dart';
import 'package:restaurant/modules/drawer/drawer.dart';
import 'package:restaurant/modules/forgotPassword/forgotPassword.dart';
import 'package:restaurant/modules/term&condition_page.dart';

var routes = <String, WidgetBuilder>{
  //add routes here
  ForgotPassword.routeName: (context) => ForgotPassword(),
  TermCondition.routeName: (context) => TermCondition(),
  PrivacyPolicy.routeName: (context) => PrivacyPolicy(),
  LayoutExample.routeName: (context) => LayoutExample(),
  
  // AddNewDish.routeName: (context) => AddNewDish(),
};
