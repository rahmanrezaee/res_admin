import 'package:flutter/material.dart';
import 'package:restaurant/modules/forgotPassword/forgotPassword.dart';
import './constants/assest_path.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: LayoutBuilder(
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
                          // Text(
                          //   "Login",
                          //   style: Theme.of(context).textTheme.headline3,
                          // ),
                          // SizedBox(height: 20),
                          Image.asset("${AssestPath.logo}", width: 150),
                          SizedBox(height: 50),
                          Form(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Login with your account",
                                    style:
                                        Theme.of(context).textTheme.headline4),
                                SizedBox(height: 15),
                                _loginFieldBuilder("Email Address"),
                                SizedBox(height: 15),
                                _loginFieldBuilder("Password"),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Row(children: [
                                    //   Text("New User? "),
                                    //   InkWell(
                                    //     onTap: () {
                                    //       // Navigator.of(context)
                                    //       //     .pushNamed(SignUpPage.routeName);
                                    //       print("Goind to singup page");
                                    //     },
                                    //     child: Text(
                                    //       "Sing Up Here",
                                    //       style: Theme.of(context).textTheme.subtitle2,
                                    //     ),
                                    //   ),
                                    // ]),
                                    InkWell(
                                      onTap: () {
                                        print("going to forgot password");
                                        Navigator.of(context).pushNamed(
                                            ForgotPassword.routeName);
                                      },
                                      child: Text(
                                        "Forgot Password",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),
                                // Row(children: [
                                //   Expanded(
                                //     child: OutlineButton(
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(8),
                                //       ),
                                //       padding: EdgeInsets.symmetric(vertical: 15),
                                //       onPressed: () {},
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: [
                                //           Image.asset(AssestPath.gmailLogo, width: 20),
                                //           SizedBox(width: 10),
                                //           Text(
                                //             "Google",
                                //             style: Theme.of(context).textTheme.subtitle1,
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                //   SizedBox(width: 15),
                                //   Expanded(
                                //     child: OutlineButton(
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(8),
                                //       ),
                                //       padding: EdgeInsets.symmetric(vertical: 15),
                                //       onPressed: () {},
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: [
                                //           Image.asset(AssestPath.facebookLogo, width: 20),
                                //           SizedBox(width: 10),
                                //           Text(
                                //             "Facebook",
                                //             style: Theme.of(context).textTheme.subtitle1,
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ])
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 100,
                      left: 0,
                      right: 0,
                      child: FractionallySizedBox(
                        widthFactor: percentage,
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          color: Theme.of(context).primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Login",
                            style: Theme.of(context).textTheme.button,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

_loginFieldBuilder(String hintText) {
  return TextField(
    decoration: InputDecoration(
      hintText: hintText,
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
    ),
  );
}
