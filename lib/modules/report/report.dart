import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/modules/report/widget/TextfieldResturant.dart';
import 'package:restaurant/modules/report/widget/buttonResturant.dart';
import 'package:restaurant/themes/colors.dart';
import '../../widgets/orderItem_widget.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          ResponsiveGridRow(children: [
            ResponsiveGridCol(
              lg: 6,
              md: 6,
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
                          "Ordered",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormFieldResturant(
                        hintText: "By Coupen",
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
                                        "From Date",
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _selectDate(context), // Refer step 3
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
                                        "From Date",
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _selectDate(context), // Refer step 3
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
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: ButtonRaiseResturant(
                              color: Theme.of(context).primaryColor,
                              label: "Email Report",
                              onPress: () {},
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ButtonRaiseResturant(
                              color: Theme.of(context).primaryColor,
                              label: "View Report",
                              onPress: () {},
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
              md: 6,
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
                          "Earning",
                          style: TextStyle(fontSize: 20),
                        ),
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
                                        "From Date",
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _selectDate(context), // Refer step 3
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
                                        "From Date",
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _selectDate(context), // Refer step 3
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
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: ButtonRaiseResturant(
                              color: Theme.of(context).primaryColor,
                              label: "Email Report",
                              onPress: () {},
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ButtonRaiseResturant(
                              color: Theme.of(context).primaryColor,
                              label: "View Report",
                              onPress: () {},
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
    );
  }

  _selectDate(BuildContext context) {
    showDatePicker(
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
            colorScheme: ColorScheme.light(primary: const Color(0xFFFFBB18)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
  }
}
