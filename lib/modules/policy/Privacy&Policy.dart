
import 'package:flutter/material.dart';
import './service/privacyPolicy_service.dart';

class PrivacyPolicy extends StatefulWidget {
  static String routeName = "PrivacyPolicy";

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  PrivacyPolicyService privacyPolicyService = new PrivacyPolicyService();
  Future getData;
  @override
  void initState() {
    super.initState();

    getData = privacyPolicyService.getPrivacy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Privacy Policy")),
      body: FutureBuilder(
          future: getData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    snapshot.data,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 14, height: 1.5),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Something went wrong!! Please check your internet connection and try again."),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
