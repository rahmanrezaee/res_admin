import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/modules/Resturant/statement/resturant_provider.dart';
import 'package:restaurant/modules/notifications/notification_page.dart';
import 'package:restaurant/modules/notifications/widget/NotificationAppBarWidget.dart';
import 'package:restaurant/modules/report/Services/ReportServices.dart';
import 'package:restaurant/modules/report/widget/TextfieldResturant.dart';
import 'package:restaurant/modules/report/widget/buttonResturant.dart';
import 'package:restaurant/responsive/functionsResponsive.dart';
import 'package:restaurant/widgets/DropDownFormField.dart';
import 'package:restaurant/widgets/appbar_widget.dart';
import '../../widgets/orderItem_widget.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  ResturantProvider snapshot;
  Future getResturantList;
  var couponController = TextEditingController();
  List<Map> listRest = [
    {"display": "All Resturant", "value": "none"}
  ];
  @override
  void initState() {
    snapshot = Provider.of<ResturantProvider>(context, listen: false);

    getResturantList = snapshot.getResturantList().then((value) {
      listRest.addAll(snapshot.listResturant.map((e) {
        return {"display": "${e.resturantName}", "value": "${e.id}"};
      }).toList());
    });
    super.initState();
  }

  DateTime selectedDate = DateTime.now();

  String orderResturantId;
  String earingResturantId;
  String startDateEarn;
  String endDateEarn;
  String startDateOrder;
  String endDateOrder;
  String income = "";
  String earning = "";

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: adaptiveAppBarBuilder(
          context,
          AppBar(
            title: Text("Reports"),
            centerTitle: true,
            actions: [NotificationAppBarWidget()],
            elevation: 0,
            leading: showAppBarNodepad(context)
                ? IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  )
                : null,
            bottom: isLoading
                ? PreferredSize(
                    preferredSize: Size(10, 10),
                    child: LinearProgressIndicator(),
                  )
                : null,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ResponsiveGridRow(children: [
                  ResponsiveGridCol(
                    lg: 6,
                    md: 12,
                    sm: 12,
                    xl: 12,
                    xs: 12,
                    child: Card(
                      margin: EdgeInsets.all(5),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Orders",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormFieldResturant(
                              hintText: "By Coupen",
                              controller: couponController,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              startDateOrder ?? "To Date",
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _selectDate(context)
                                                  .then((value) => setState(() {
                                                        startDateOrder = value;
                                                      }));
                                            },
                                            icon: Icon(
                                              Icons.calendar_today,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              endDateOrder ?? "From Date",
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _selectDate(context)
                                                  .then((value) => setState(() {
                                                        endDateOrder = value;
                                                      }));
                                            }, // Refer step 3
                                            icon: Icon(
                                              Icons.calendar_today,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: earning != "",
                              child: ListTile(
                                title: Text("Total Orders"),
                                trailing: Text("$earning"),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                  child: ButtonRaiseResturant(
                                    color: Theme.of(context).primaryColor,
                                    label: Text(
                                      "Email Report",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    onPress: () {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      getSendReportEmil(
                                        fromDate: startDateOrder,
                                        toDate: endDateOrder,
                                        coupenCode: couponController.text,
                                      ).then((value) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          backgroundColor: Colors.greenAccent,
                                          content: Text(
                                              "Successfuly Send To Email."),
                                          duration: Duration(seconds: 3),
                                        ));
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: ButtonRaiseResturant(
                                    color: Theme.of(context).primaryColor,
                                    label: Text(
                                      "View Report",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    onPress: () {
                                      setState(() {
                                        isLoading = true;
                                        earning = "";
                                      });
                                      getReport(
                                        type: "orders",
                                        fromDate: startDateOrder,
                                        toDate: endDateOrder,
                                        coupenCode: couponController.text,
                                      ).then((value) {
                                        setState(() {
                                          earning = "${value}";

                                          isLoading = false;
                                        });
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  ResponsiveGridCol(
                    lg: 6,
                    md: 12,
                    sm: 12,
                    xl: 12,
                    xs: 12,
                    child: Card(
                      margin: EdgeInsets.all(5),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Earnings",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              startDateEarn ?? "From Date",
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _selectDate(context)
                                                  .then((value) {
                                                setState(() {
                                                  print("date $value");
                                                  startDateEarn = value;
                                                });
                                              });
                                            }, // Refer step 3
                                            icon: Icon(
                                              Icons.calendar_today,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              endDateEarn ?? "To Date",
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _selectDate(context)
                                                  .then((value) {
                                                setState(() {
                                                  print("date $value");
                                                  endDateEarn = value;
                                                });
                                              });
                                            }, // Refer step 3
                                            icon: Icon(
                                              Icons.calendar_today,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: income != "",
                              child: ListTile(
                                title: Text("Total Earning"),
                                trailing: Text("$income"),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                  child: ButtonRaiseResturant(
                                    color: Theme.of(context).primaryColor,
                                    label: Text(
                                      "Email Report",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    onPress: () {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      getSendReportEmailEarnings(
                                        fromDate: startDateEarn,
                                        toDate: endDateEarn,
                                      ).then((value) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          backgroundColor: Colors.greenAccent,
                                          content: Text(
                                              "Successfuly Send To Email."),
                                          duration: Duration(seconds: 3),
                                        ));
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: ButtonRaiseResturant(
                                    color: Theme.of(context).primaryColor,
                                    label: Text(
                                      "View Report",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    onPress: () {
                                      setState(() {
                                        isLoading = true;

                                        income = "";
                                      });
                                      getReport(
                                        type: "earnings",
                                        fromDate: startDateEarn,
                                        toDate: endDateEarn,
                                      ).then((value) {
                                        setState(() {
                                          income = "${value}";

                                          isLoading = false;
                                        });
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ));
  }

  Future<String> _selectDate(BuildContext context) async {
    final dateResult = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.input,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColor,
            accentColor: Theme.of(context).primaryColor,
            colorScheme: ColorScheme.light(primary: const Color(0xFF000000)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );

    if (dateResult != null)
      return "${dateResult.year}-${dateResult.month}-${dateResult.day}";
  }
}
