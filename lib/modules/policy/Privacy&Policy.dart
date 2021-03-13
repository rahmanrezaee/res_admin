import 'package:flutter/material.dart';
import './service/privacyPolicy_service.dart';

class PrivacyPolicy extends StatelessWidget {
  static String routeName = "PrivacyPolicy";
  PrivacyPolicyService privacyPolicyService = new PrivacyPolicyService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy and Policy",
            style: Theme.of(context).textTheme.button),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: privacyPolicyService.getPrivacy(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(snapshot.data),
                ),
              );
            } else if (snapshot.hasError) {
              return Text(
                  "Something went wrong!! Please check your internet connection and try again.");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
