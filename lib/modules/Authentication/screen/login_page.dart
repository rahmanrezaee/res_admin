import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:restaurant/modules/policy/Privacy&Policy.dart';
import 'package:restaurant/modules/term/term&condition_page.dart';

import '../providers/auth_provider.dart';
import '../validators/formFieldsValidators.dart';
import '../../../themes/colors.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:restaurant/modules/Authentication/validators/formFieldsValidators.dart';
import 'package:restaurant/themes/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/assest_path.dart';
import '../../drawer/drawer.dart';
import '../../Authentication/screen/forgotPasswordWithKey.dart';

import 'package:restaurant/responsive/functionsResponsive.dart';
import './forgotPassword.dart';
import '../providers/linkListener.dart';
import 'package:uni_links/uni_links.dart';

import 'forgotPasswordWithKey.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "loginpage";
  @override
  _LoginPageState createState() => _LoginPageState();
}

bool first = true;

class _LoginPageState extends State<LoginPage> {
  StreamSubscription _sub;
  String _latestLink = 'Unknown';
  Uri _latestUri;

  /// An implementation using a [String] link
  initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = getLinksStream().listen((String link) {
      if (!mounted) return;
      _latestLink = link ?? 'Unknown';
      _latestUri = null;
      try {
        if (link != null) {
          String token = link.toString().substring(
              link.toString().indexOf("token=") + 6, link.toString().length);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ForgotPasswordWithKey(token);
          }));
        }
      } on FormatException {}
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestLink = 'Failed to get latest link: $err.';
        _latestUri = null;
      });
    });

    // Get the latest link
    String initialLink;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      //   print('initial link: $initialLink');
      if (initialLink != null && first == true) {
        first = false;
        String token = initialLink.toString().substring(
            initialLink.toString().indexOf("token=") + 6,
            initialLink.toString().length);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ForgotPasswordWithKey(token);
        }));
      }
    } on FormatException {}
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  final _formKey = GlobalKey<FormState>();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  String fcmToken = "fcm token";
  TextEditingController _emailController = new TextEditingController();

  TextEditingController _passwordController = new TextEditingController();

  AuthProvider authProvider;
  StreamSubscription iosSubscription;

  @override
  void dispose() {
    if (iosSubscription != null) iosSubscription.cancel();
    if (_sub != null) _sub.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // initUniLinks(context);
    initPlatformStateForStringUniLinks();
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
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
        child: LayoutBuilder(builder: (context, constraints) {
          double contentSize = MediaQuery.of(context).size.width;
          double percentage = 1; //1 = 100%, .8 = 80% ...
          if (constraints.maxWidth > 1024) {
            percentage = .3;
            contentSize = MediaQuery.of(context).size.width / 2;
          } else if (constraints.maxWidth > 660.0) {
            percentage = .4;
            contentSize = MediaQuery.of(context).size.width / 1.8;
          } else {
            percentage = .9;
            contentSize = MediaQuery.of(context).size.width / .8;
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: contentSize,
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
                              ),
                              SizedBox(height: 15),
                              _loginFieldBuilder(
                                "Password",
                                passwordValidator,
                                _passwordController,
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
                                      "Forgot Password",
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
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
                                  style: Theme.of(context).textTheme.subtitle2,
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
                                  style: Theme.of(context).textTheme.subtitle2,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        print("going to forgot password");
                        Navigator.of(context)
                            .pushNamed(ForgotPassword.routeName);
                      },
                      child: Text(
                        "Forgot Password?",
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                error == null
                    ? Container()
                    : Text(error, style: TextStyle(color: AppColors.redText)),
                SizedBox(height: 10),
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
                                style: Theme.of(context).textTheme.button,
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
              ],
            ),
          );
        }),
      ),
    ));
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
        print("This is the response");
        print(res);
        setState(() {
          loading = false;
        });

        if (res != null) {
          if (res['status'] == true) {
            print(res);
            setState(() {
              error = null;
            });
            Navigator.pushReplacementNamed(context, LayoutExample.routeName);
          } else {
            print("There we have error");
            setState(() {
              error = res['message'];
            });
          }
        }
      }).catchError((e, s) {
        print(s);
        print(e);
        print("Ti=");
      });
    }
  }
}

_loginFieldBuilder(
    String hintText, Function validator, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    validator: (v) {
      return validator(v);
    },
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