import 'package:flutter/material.dart';
import './services/term&condition_service.dart';

class TermCondition extends StatelessWidget {
  static String routeName = "TermCondition";
  TermConditionService termConditionService = new TermConditionService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and Conditions",
            style: Theme.of(context).textTheme.button),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: termConditionService.getTerm(),
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
