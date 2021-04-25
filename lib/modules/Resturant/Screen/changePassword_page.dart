import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
//widgets
// import '../../widgets/notificationIcon_page.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPass = TextEditingController();

  final TextEditingController _newPass = TextEditingController();

  final TextEditingController _confirmPass = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> scoffeldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scoffeldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Change Password",
        ),
        actions: [
          // NotificationIcon(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Change your Password",
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _oldPass,
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Please Enter your Old Password.";
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter Old Password",
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.only(left: 10),
                  errorStyle: TextStyle(color: Colors.red),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _newPass,
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Please Enter your New Password.";
                  }
                  if (_oldPass.text == value) {
                    return "New Password Is Same Old Password.";
                  }

                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter New Password",
                  errorStyle: TextStyle(color: Colors.red),
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.only(left: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _confirmPass,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please Enter Confirm New Password.";
                  }

                  if (_newPass.text != _confirmPass.text) {
                    return "Password does not match";
                  }
                  bool isPasswordCompliant(String _newPass,
                      [int minLength = 4]) {
                    if (_newPass == null || _newPass.isEmpty) {
                      return false;
                    }
                    bool hasMinLength = _newPass.length > minLength;

                    return hasMinLength;
                  }

                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm New Password",
                  hintStyle: TextStyle(color: Colors.grey),
                  errorStyle: TextStyle(color: Colors.red),
                  contentPadding: EdgeInsets.only(left: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          "Change Password",
                          style: Theme.of(context).textTheme.button,
                        ),
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      Provider.of<AuthProvider>(context, listen: false)
                          .submitPass(
                        _oldPass.text,
                        _newPass.text,
                      )
                          .then((value) {
                        setState(() {
                          _isLoading = false;
                        });
                        if (value['status']) {
                          scoffeldKey.currentState.showSnackBar(SnackBar(
                            content: Text(value['message']),
                            backgroundColor: Colors.green,
                            duration: new Duration(milliseconds: 2000),
                          ));

                          Timer(Duration(seconds: 2), () {
                            Navigator.pop(context);
                          });
                        } else {
                          scoffeldKey.currentState.showSnackBar(SnackBar(
                            content: Text(value['message']),
                            backgroundColor: Colors.red,
                            duration: new Duration(milliseconds: 3000),
                          ));
                        }
                        print(value);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
