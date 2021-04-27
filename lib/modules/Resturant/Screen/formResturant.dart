import 'dart:async';

import 'package:geocoder/geocoder.dart';
import 'package:restaurant/Services/UploadFile.dart';
import 'package:restaurant/constants/UrlConstants.dart';
import 'package:restaurant/constants/assest_path.dart';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:restaurant/modules/Authentication/screen/login_page.dart';
import 'package:restaurant/modules/Resturant/Models/Resturant.dart';
import 'package:restaurant/modules/Resturant/Models/location.dart';
import 'package:restaurant/modules/Resturant/Screen/changePassword_page.dart';
import 'package:restaurant/modules/Resturant/statement/resturant_provider.dart';
import 'package:restaurant/modules/dashboard/provider/dashboard_provider.dart';
import 'package:restaurant/modules/notifications/notification_page.dart';
import 'package:restaurant/modules/notifications/widget/NotificationAppBarWidget.dart';
import 'package:restaurant/modules/report/widget/TextfieldResturant.dart';
import 'package:restaurant/modules/report/widget/buttonResturant.dart';
import 'package:restaurant/responsive/functionsResponsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
//packages
import 'package:responsive_grid/responsive_grid.dart';
import 'package:restaurant/widgets/appbar_widget.dart';
import 'package:string_validator/string_validator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ResturantForm extends StatefulWidget {
  static final routeName = "resturantform";
  @override
  _ResturantFormState createState() => _ResturantFormState();
}

class _ResturantFormState extends State<ResturantForm> {
  bool _isUploadingImage = false;
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _autoValidate = false;
  bool _isLoading = false;
  bool _isLoadingTop = false;
  TextEditingController locationPickerController = new TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  ResturantModel resturantModel = new ResturantModel();
  LocationModel locationMo = new LocationModel();
  bool _loadUpdate = false;

  Future<String> _selectTime(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());

    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: const Color(0xFF504d4d),
                accentColor: const Color(0xFF504d4d),
                colorScheme:
                    ColorScheme.light(primary: const Color(0xFF504d4d)),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child,
              ));
        });

    if (picked_s != null) return "${picked_s.hour}:${picked_s.minute}";
  }

  DashboardProvider dashboardProvider;
  @override
  void initState() {
    dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
    getRestuantData();
    super.initState();
  }

  String addressLine = "Loading";
  void getRestuantData() {
    AuthProvider().resturantId().then((value) {
      Provider.of<ResturantProvider>(context, listen: false)
          .getSingleResturant(value)
          .then((value) {
        setState(() {
          resturantModel = value;
        });
        print(
            "lat ${resturantModel.location.lat} ${resturantModel.location.log}");
        final coordinates = new Coordinates(
            resturantModel.location.lat, resturantModel.location.log);

        Geocoder.google("AIzaSyBY1nLDcGY1NNgV89rnDR8jg_eBsQBJ39E")
            .findAddressesFromCoordinates(coordinates)
            .then((value) {
          List<Address> addresses = value;
          print("address ${value[0].addressLine}");

          setState(() {
            if (addresses.isNotEmpty) {
              Address first = addresses[0];

              addressLine = "(${first.addressLine})";
            } else {
              addressLine = "Not Found Address";
            }
          });
        });

        _loadUpdate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: .2,
          title: Text("My Profile"),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
            showAppBarNodepad(context) ? NotificationAppBarWidget() : SizedBox()
          ],
          leading: showAppBarNodepad(context)
              ? IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                )
              : SizedBox(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          bottom: _isLoadingTop
              ? PreferredSize(
                  preferredSize: Size(10, 10),
                  child: LinearProgressIndicator(),
                )
              : null,
        ),
        body: _loadUpdate
            ? SingleChildScrollView(
                child: Form(
                  autovalidate: _autoValidate,
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                            height: 100,
                            width: 100,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: ClipRRect(
                              child: new Container(
                                width: 70,
                                height: 70,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(70.0)),
                                  border: new Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 4.0,
                                  ),
                                ),
                                child: _isUploadingImage
                                    ? SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircularProgressIndicator())
                                    : resturantModel.avatar != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(70.0),
                                            child: Stack(
                                              children: [
                                                Image.network(
                                                    resturantModel.avatar),
                                              ],
                                            ))
                                        : Icon(Icons.add_a_photo),
                              ),
                            )),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "${resturantModel.resturantName}",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  )),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(child: Text("$addressLine")),
                                ],
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                      ]),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Open for Orders",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                                CupertinoSwitch(
                                  value: resturantModel.openForOrder,
                                  onChanged: (value) {
                                    setState(() {
                                      _isLoadingTop = true;
                                    });
                                    dashboardProvider
                                        .resturantChangeStateOpenForOrder(
                                            resturantModel.id, value)
                                        .then((done) {
                                      setState(() {
                                        resturantModel.openForOrder = value;
                                        _isLoadingTop = false;
                                      });
                                    });
                                  },
                                  // trackColor: AppColors.green,
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Auto Accept Orders",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                                CupertinoSwitch(
                                  value: resturantModel.autoAcceptOrder,
                                  onChanged: (value) {
                                    setState(() {
                                      _isLoadingTop = true;
                                    });
                                    dashboardProvider
                                        .resturantChangeStateAutoAcceptOrder(
                                            resturantModel.id, value)
                                        .then((done) {
                                      setState(() {
                                        resturantModel.autoAcceptOrder = value;
                                        _isLoadingTop = false;
                                      });
                                    });
                                  },
                                  // trackColor: AppColors.green,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Row(children: [
                              Visibility(
                                child: Expanded(
                                  child: RaisedButton(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    color: Theme.of(context).primaryColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Change Password",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChangePasswordPage()),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ]),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                color: Theme.of(context).primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Log Out",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.exit_to_app,
                                      color: Colors.white,
                                      size: 25,
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    CupertinoPageRoute(
                                        builder: (context) => LoginPage()),
                                    (_) => false,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  Expanded(child: _dataBody()),
                                ],
                              )),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: getQurIpadAndFullMobWidth(context),
                            child: ButtonRaiseResturant(
                              color: Theme.of(context).primaryColor,
                              label: _isLoading == true
                                  ? SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator())
                                  : Text(
                                      "Update",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                              onPress: () {
                                addResturant();
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }

  addResturant() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      var resturantProvider =
          Provider.of<ResturantProvider>(context, listen: false);

      resturantProvider
          .editResturant(
              resturantModel.sendMap(), await AuthProvider().resturantId())
          .then((result) {
        setState(() {
          _isLoading = false;
        });

        if (result == true) {
          print("Mahdi: Executed 2");
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Successfuly Updated."),
            duration: Duration(seconds: 3),
          ));
        } else {
          print("Mahdi: Executed 3");

          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Something went wrong!! Please try again later."),
            duration: Duration(seconds: 4),
          ));
        }

        print("Mahdi: Executed 4");
      }).catchError((error) {
        print("Mahdi Error: $error");
        setState(() {
          _isLoading = false;
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Something went wrong!! Please try again later."),
          duration: Duration(seconds: 4),
        ));
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

// Let's create a DataTable and show the employee list in it.
  Widget _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child:
            DataTable(dataTextStyle: TextStyle(color: Colors.black), columns: [
          DataColumn(
              label: Text(
            'Timings',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          )),
          DataColumn(
              label: Text(
            'Open',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          )),
          DataColumn(
              label: Text(
            'Close',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          )),
        ], rows: [
          DataRow(
            cells: [
              DataCell(Text("Sunday")),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.sunday.startTime == null ? '0:00' : resturantModel.sunday.startTime}"),
                    IconButton(
                      icon: Image.asset("assets/images/edit.png"),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.sunday.startTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.sunday.endTime == null ? '0:00' : resturantModel.sunday.endTime}"),
                    IconButton(
                      icon: Image.asset("assets/images/edit.png"),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.sunday.endTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Monday")),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.monday.startTime == null ? '0:00' : resturantModel.monday.startTime}"),
                    IconButton(
                      icon: Image.asset("assets/images/edit.png"),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.monday.startTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.monday.endTime == null ? '0:00' : resturantModel.monday.endTime}"),
                    IconButton(
                      icon: Image.asset("assets/images/edit.png"),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.monday.endTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Tuesday")),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.tuesday.startTime == null ? '0:00' : resturantModel.tuesday.startTime}"),
                    IconButton(
                      icon: Image.asset("assets/images/edit.png"),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.tuesday.startTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.tuesday.endTime == null ? '0:00' : resturantModel.tuesday.endTime}"),
                    IconButton(
                      icon: Image.asset("assets/images/edit.png"),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.tuesday.endTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Wednesday")),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.wednesday.startTime == null ? '0:00' : resturantModel.wednesday.startTime}"),
                    IconButton(
                      icon: Image.asset("assets/images/edit.png"),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.wednesday.startTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.wednesday.endTime == null ? '0:00' : resturantModel.wednesday.endTime}"),
                    IconButton(
                      icon: Image.asset("assets/images/edit.png"),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.wednesday.endTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Thursday")),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.thursday.startTime == null ? '0:00' : resturantModel.thursday.startTime}"),
                    IconButton(
                      icon: Image.asset("assets/images/edit.png"),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.thursday.startTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.thursday.endTime == null ? '0:00' : resturantModel.thursday.endTime}"),
                    IconButton(
                      icon: Image.asset("assets/images/edit.png"),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.thursday.endTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Friday")),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.friday.startTime == null ? '0:00' : resturantModel.friday.startTime}"),
                    IconButton(
                      icon: Image.asset("assets/images/edit.png"),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.friday.startTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.friday.endTime == null ? '0:00' : resturantModel.friday.endTime}"),
                    IconButton(
                      icon: Image.asset("assets/images/edit.png"),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.friday.endTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Saturday")),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.saturday.startTime == null ? '0:00' : resturantModel.saturday.startTime}"),
                    IconButton(
                      icon: Image.asset("assets/images/edit.png"),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.saturday.startTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.saturday.endTime == null ? '0:00' : resturantModel.saturday.endTime}"),
                    IconButton(
                      icon: Image.asset("assets/images/edit.png"),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.saturday.endTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
