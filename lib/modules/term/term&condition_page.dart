
import 'package:flutter/material.dart';
import './services/term&condition_service.dart';

class TermCondition extends StatefulWidget {
  static String routeName = "TermCondition";

  @override
  _TermConditionState createState() => _TermConditionState();
}

class _TermConditionState extends State<TermCondition> {
  TermConditionService termConditionService = new TermConditionService();

  Future getData;

  @override
  void initState() {
    super.initState();
    getData = termConditionService.getTerm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Terms and Conditions")),
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
