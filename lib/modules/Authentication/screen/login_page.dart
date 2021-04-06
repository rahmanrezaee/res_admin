import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:restaurant/modules/Authentication/validators/formFieldsValidators.dart';
import 'package:restaurant/modules/policy/Privacy&Policy.dart';
import 'package:restaurant/modules/term/term&condition_page.dart';
import 'package:restaurant/responsive/functionsResponsive.dart';
import 'package:restaurant/themes/colors.dart';
import '../../../constants/assest_path.dart';
import '../../drawer/drawer.dart';
import './forgotPassword.dart';
import '../providers/linkListener.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "loginpage";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String fcmToken = "fcm token";
  TextEditingController _emailController = new TextEditingController();

  TextEditingController _passwordController = new TextEditingController();

  AuthProvider authProvider;
  StreamSubscription iosSubscription;

  @override
  void dispose() {
    if (iosSubscription != null) iosSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    initUniLinks(context);
    getFcmToken();
    super.initState();
  }

  Future<void> getFcmToken() async {
    print('get Fcm Token');

    FirebaseMessaging.instance.getToken().then((valu) {
      this.fcmToken = valu;
      log("firebase token $fcmToken");
    });
  }

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Image.asset("${AssestPath.logo}", width: 150),
                SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        Image.asset("${AssestPath.logo}", width: 150),
                        SizedBox(height: 50),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Login with your account",
                                  style: Theme.of(context).textTheme.headline4),
                              SizedBox(height: 15),
                              _loginFieldBuilder(
                                "Email Address",
                                emailValidator,
                                _emailController,
                                false,
                              ),
                              SizedBox(height: 15),
                              _loginFieldBuilder(
                                "Password",
                                passwordValidator,
                                _passwordController,
                                true,
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      print("Going to forgot password");
                                      Navigator.of(context)
                                          .pushNamed(ForgotPassword.routeName);
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        Container(
                          width: getHelfIpadAndFullMobWidth(context),
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            color: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                loading == true
                                    ? CircularProgressIndicator()
                                    : Text(
                                        "Login",
                                        textAlign: TextAlign.center,
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                              ],
                            ),
                            onPressed: () {
                              login();
                              // Navigator.pushReplacementNamed(
                              //     context, LayoutExample.routeName);
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              text: "By using this app you are accepting our ",
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context)
                                          .pushNamed(TermCondition.routeName);
                                    },
                                  text: "Terms and Conditions",
                                  style: TextStyle(color: AppColors.green),
                                ),
                                TextSpan(
                                  text: " and ",
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print('privacy policy');
                                      Navigator.of(context).pushNamed(
                                          PrivacyPolicy.routeName,
                                          arguments: "login");
                                    },
                                  text: "Privacy Policy",
                                  style: TextStyle(color: AppColors.green),
                                ),
                              ]),
                        ),
                        SizedBox(height: 20),
                        error == null
                            ? Container()
                            : Text(error,
                                style: TextStyle(color: AppColors.redText)),
                        SizedBox(height: 10),
                        // RaisedButton(
                        //   padding: EdgeInsets.symmetric(vertical: 15),
                        //   color: Theme.of(context).primaryColor,
                        //   elevation: 0,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   focusedBorder: OutlineInputBorder(
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(10.0)),
                        //     borderSide: BorderSide(color: Colors.grey),
                        //   ),
                        // ),
                      ]),
                ),
                SizedBox(height: 15),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     InkWell(
                //       onTap: () {
                //         print("going to forgot password");
                //         Navigator.of(context)
                //             .pushNamed(ForgotPassword.routeName);
                //       },
                //       child: Text(
                //         "Forgot Password?",
                //         style: Theme.of(context).textTheme.subtitle2,
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 20),
                SizedBox(height: 20),
                error == null
                    ? Container()
                    : Text(error, style: TextStyle(color: AppColors.redText)),
                SizedBox(height: 10),
                // Container(
                //   // width: getHelfIpadAndFullMobWidth(context),
                //   child: RaisedButton(
                //     padding: EdgeInsets.symmetric(vertical: 15),
                //     color: Theme.of(context).primaryColor,
                //     elevation: 0,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         loading == true
                //             ? CircularProgressIndicator()
                //             : Text(
                //                 "Login",
                //                 textAlign: TextAlign.center,
                //                 style: Theme.of(context).textTheme.button,
                //               ),
                //       ],
                //     ),
                //     onPressed: () {
                //       login();
                //       // Navigator.pushReplacementNamed(
                //       //     context, LayoutExample.routeName);
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool loading = false;
  String error;
  login() {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      String email = _emailController.text;
      String password = _passwordController.text;
      authProvider.login(email, password, this.fcmToken).then((res) {
        setState(() {
          loading = false;
        });

        log("res $res");
        if (res['status'] == true) {
          setState(() {
            error = null;
          });
          Navigator.pushReplacementNamed(context, LayoutExample.routeName);
        } else {
          setState(() {
            error = res['message'];
          });
        }
      });
    }
  }
}

_loginFieldBuilder(String hintText, Function validator,
    TextEditingController controller, bool secure) {
  return TextFormField(
    controller: controller,
    validator: (v) {
      return validator(v);
    },
    obscureText: secure,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey),
      contentPadding: EdgeInsets.only(left: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: AppColors.redText),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
  );
}
