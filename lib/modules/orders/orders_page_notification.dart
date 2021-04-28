import 'package:restaurant/modules/notifications/notification_page.dart';
import 'package:restaurant/modules/notifications/widget/NotificationAppBarWidget.dart';
import 'package:restaurant/responsive/functionsResponsive.dart';
import 'package:restaurant/widgets/appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../widgets/orderItem_widget.dart';

//
import 'package:responsive_grid/responsive_grid.dart';

class OrdersPageNotification extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrdersPageNotification>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  TabBar get _tabBar => TabBar(
        indicatorWeight: 2,
        indicatorColor: Colors.blue[100],
        controller: _tabController,
        onTap: (v) {
          setState(() {
            print(_tabController.index);
          });
        },
        indicatorPadding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        unselectedLabelColor: AppColors.green,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
            // borderRadius: BorderRadius.circular(0),
            ),
        tabs: [
          Tab(
            child: Container(
              decoration: BoxDecoration(
                  color: _tabController.index == 0
                      ? AppColors.green
                      : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  border: Border.all(color: AppColors.green, width: 1)),
              child: Align(
                alignment: Alignment.center,
                child: Text("New Orders"),
              ),
            ),
            iconMargin: EdgeInsets.zero,
          ),
          Tab(
            iconMargin: EdgeInsets.zero,
            child: Container(
              decoration: BoxDecoration(
                  color: _tabController.index == 1
                      ? AppColors.green
                      : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  border: Border.all(color: AppColors.green, width: 1)),
              child: Align(
                alignment: Alignment.center,
                child: Text("Past Orders"),
              ),
            ),
          ),
        ],
      );
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: showAppBarNodepad(context)
          ? adaptiveAppBarBuilder(
              context,
              AppBar(
                title: Text("Order Page"),
                centerTitle: true,
                actions: [NotificationAppBarWidget()],
                elevation: 0,
              ),
            )
          : AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: _tabBar),
      body: Column(
        children: [
          Visibility(
            visible: showAppBarNodepad(context),
            child: Padding(padding: new EdgeInsets.all(10), child: _tabBar),
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                OrderItem(
                  status: "new",
                  scaffoldKey: _scaffoldKey,
                ),
                OrderItem(
                  status: "past",
                  scaffoldKey: _scaffoldKey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
