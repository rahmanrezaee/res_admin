import 'package:flutter/material.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';
import 'package:restaurant/constants/assest_path.dart';
import 'package:restaurant/modules/addNewDish/addNewDish_page.dart';
import 'package:restaurant/modules/report/report.dart';
import 'package:restaurant/themes/colors.dart';
import 'package:restaurant/themes/style.dart';
//pages
import '../dashboard/dashboard_page.dart';
import '../orders/orders_page.dart';
import '../myProfile/myProfile_page.dart';
import '../categories/catetories_page.dart';
import '../dishes/dishes_page.dart';
import '../notifications/notifications_page.dart';

class PageModel {
  String title;
  Widget icon;
  Widget page;
  PageModel({this.title, this.icon, this.page});
}

class LayoutExample extends StatefulWidget {
  @override
  _LayoutExampleState createState() => _LayoutExampleState();
}

class _LayoutExampleState extends State<LayoutExample> {
  List<PageModel> pages = [
    PageModel(
      title: "Dashboard",
      icon: SizedBox(
        width: 25,
        height: 25,
        child: Image.asset(AssestPath.dashboardIcon, fit: BoxFit.cover),
      ),
      page: DashboardPage(),
    ),
    PageModel(
      title: "Orders",
      icon: Icon(Icons.room_service, color: AppColors.green),
      page: OrderPage(),
    ),
    PageModel(
      title: "My Profile",
      icon: Icon(Icons.account_circle_outlined, color: Colors.yellow),
      page: MyProfilePage(),
    ),
    PageModel(
      title: "Categories",
      icon: SizedBox(
        width: 25,
        height: 25,
        child: Image.asset(AssestPath.categoriesIcon, fit: BoxFit.cover),
      ),
      page: CatetoriesPage(),
    ),
    PageModel(
      title: "Dishes",
      icon: SizedBox(
        width: 25,
        height: 25,
        child: Image.asset(AssestPath.dishesIcon, fit: BoxFit.cover),
      ),
      page: DishPage(),
    ),
    PageModel(
      title: "Notifications",
      icon: Icon(Icons.notifications_outlined, color: Colors.yellow),
      page: NotificationsPage(),
    ),
    PageModel(
      title: "Report",
      icon: Icon(Icons.report, color: Colors.yellow),
      page: ReportPage(),
    ),
  ];

  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      kDesktopBreakpoint: 768,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: pages[pageIndex].page,
      ),
      drawer: SizedBox(
        width: 281,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
              ...pages.map((page) {
                int index = pages.indexOf(page);

                return drawerListItemBuilder(
                  icon: page.icon,
                  title: page.title,
                  isActive: pageIndex == index,
                  onClick: () {
                    setState(() {
                      pageIndex = index;
                    });
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

drawerListItemBuilder({
  @required Widget icon,
  @required String title,
  bool isActive,
  @required Function onClick,
}) {
  return InkWell(
    onTap: () {
      onClick();
    },
    child: Card(
      color:
          isActive != null && isActive ? Colors.yellow.shade100 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            icon,
            SizedBox(width: 10),
            Text(title),
          ],
        ),
      ),
    ),
  );
}
