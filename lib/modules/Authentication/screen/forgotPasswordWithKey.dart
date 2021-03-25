import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:restaurant/modules/Authentication/screen/login_page.dart';
import 'package:restaurant/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../validators/formFieldsValidators.dart';

class ForgotPasswordWithKey extends StatefulWidget {
  static String routeName = "ForgotPasswordWithKey";
  final String forgotPasswordToken;
  ForgotPasswordWithKey(this.forgotPasswordToken);
  @override
  _ForgotPasswordWithKeyState createState() => _ForgotPasswordWithKeyState();
}

class _ForgotPasswordWithKeyState extends State<ForgotPasswordWithKey> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _repeadPasswordController = new TextEditingController();

  TextEditingController _passwordController = new TextEditingController();

  AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rest Password",
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
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
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: contentSize,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Forgotten your Password ? Don't worry just choose a new password.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Enter New Password",
                                style: Theme.of(context).textTheme.headline4),
                          ),
                          SizedBox(height: 15),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _loginFieldBuilder(
                                    "New Password", _passwordController, (v) {
                                  print(v);
                                  if (v == '') {
                                    return "Please add more character!";
                                  }
                                }),
                                SizedBox(height: 10),
                                _loginFieldBuilder("Repead Password",
                                    _repeadPasswordController, (v) {
                                  if (v == '' ||
                                      v != _passwordController.text) {
                                    return "Its not match with new password!";
                                  }
                                }),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            width: contentSize - 100,
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              color: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: loading == true
                                  ? CircularProgressIndicator()
                                  : Text(
                                      "Submit",
                                      style: Theme.of(context).textTheme.button,
                                    ),
                              onPressed: () {
                                forgotPasswordWithKey();
                              },
                            ),
                          ),
                          SizedBox(height: 100),
                        ],
                      ),
                    ),
                    error != null
                        ? Text(
                            error,
                            style: TextStyle(color: AppColors.redText),
                          )
                        : Container(),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool loading = false;
  String error;
  forgotPasswordWithKey() {
    print("Forgoting password with key");
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      String password = _passwordController.text;
      authProvider
          .forgotPasswordWithKey(password, widget.forgotPasswordToken)
          .then((res) {
        setState(() {
          loading = false;
        });
        if (res['status'] == true) {
          Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
          setState(() {
            error = null;
          });
        } else {
          setState(() {
            print(res['message']);
            error = res['message'];
          });
        }
      });
    }
  }
}

_loginFieldBuilder(
    String hintText, TextEditingController controller, Function validator) {
  return TextFormField(
    controller: controller,
    validator: (e) {
      print(e);
      return validator(e);
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
        borderSide: BorderSide(color: AppColors.redText),
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
