import 'package:restaurant/modules/dashboard/widget/label.dart';
import 'package:restaurant/modules/notifications/notification_page.dart';
import 'package:restaurant/modules/report/widget/buttonResturant.dart';
import 'package:restaurant/responsive/functionsResponsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/modules/dishes/Screen/addNewDish_page.dart';
import 'package:restaurant/themes/colors.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
//provider
import '../provider/dashboard_provider.dart';
//widgets
import '../../../themes/style.dart';
import '../../../widgets/appbar_widget.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
      SystemChrome.setEnabledSystemUIOverlays([]);
    }

    return Scaffold(
      appBar: adaptiveAppBarBuilder(
        context,
        AppBar(
          title: Text("Dashboard"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Image.asset("assets/images/notification.png"),
              onPressed: () {
                Navigator.pushNamed(context, NotificationPage.routeName);
              },
            )
          ],
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          bottom: isLoading
              ? PreferredSize(
                  preferredSize: Size(10, 10),
                  child: LinearProgressIndicator(),
                )
              : null,
        ),
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, dashProvider, child) {
          return dashProvider.getDashData == null
              ? FutureBuilder(
                  future: dashProvider.fetchDashData(),
                  builder: (context, snapshot) {
                    return Center(child: CircularProgressIndicator());
                  })
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Open for Orders",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700)),
                            CupertinoSwitch(
                              value: dashProvider.openForOrder,
                              onChanged: (value) {
                                setState(() {
                                  isLoading = true;
                                });
                                dashProvider
                                    .resturantChangeStateOpenForOrder(
                                        dashProvider.getDashData['restaurant']
                                            ['_id'],
                                        value)
                                    .then((value) => {
                                          setState(() {
                                            isLoading = false;
                                          })
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
                                    fontSize: 18, fontWeight: FontWeight.w700)),
                            CupertinoSwitch(
                              value: dashProvider.autoAcceptOrder,
                              onChanged: (value) {
                                setState(() {
                                  isLoading = true;
                                });
                                dashProvider
                                    .resturantChangeStateAutoAcceptOrder(
                                        dashProvider.getDashData['restaurant']
                                            ['_id'],
                                        value)
                                    .then((value) => {
                                          setState(() {
                                            isLoading = false;
                                          })
                                        });
                                ;
                              },
                              // trackColor: AppColors.green,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: getHelfIpadAndFullMobWidth(context),
                            height: 50,
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              color: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${dashProvider.getDashData['activeOrders']} Active Orders",
                                style: Theme.of(context).textTheme.button,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            width: getQurIpadAndFullMobWidth(context),
                            child: LabelDashBoard(
                              color: Colors.white,
                              title:
                                  "Total earning Today: ${dashProvider.getDashData['totalEarningToday']} \$",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
