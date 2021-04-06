import 'package:restaurant/modules/Authentication/screen/forgotPassword.dart';
import 'package:restaurant/modules/Authentication/screen/forgotPasswordWithKey.dart';
import 'package:restaurant/modules/Authentication/screen/login_page.dart';
import 'package:restaurant/modules/customers/screen/Customers_page.dart';
import 'package:restaurant/modules/dishes/Screen/dishes_page.dart';
import 'package:restaurant/modules/drawer/drawer.dart';
import 'package:restaurant/modules/notifications/notification_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant/modules/policy/Privacy&Policy.dart';
import 'package:restaurant/modules/term/term&condition_page.dart';

var routes = <String, WidgetBuilder>{
  LayoutExample.routeName: (context) => LayoutExample(),
  ForgotPassword.routeName: (context) => ForgotPassword(),
  TermCondition.routeName: (context) => TermCondition(),
  PrivacyPolicy.routeName: (context) => PrivacyPolicy(),
  CustomersPage.routeName: (context) => CustomersPage(),
  LoginPage.routeName: (context) => LoginPage(),
  NotificationPage.routeName: (context) => NotificationPage(),
  ForgotPasswordWithKey.routeName: (context) =>
      ForgotPasswordWithKey(ModalRoute.of(context).settings.arguments),
  // AddNewDish.routeName: (context) => AddNewDish(),
};
