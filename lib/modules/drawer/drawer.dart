import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:restaurant/modules/Authentication/screen/login_page.dart';
import 'package:restaurant/modules/Resturant/Screen/formResturant.dart';
import 'package:restaurant/modules/notifications/notification_page.dart';
import 'package:restaurant/modules/notifications/widget/NotificationAppBarWidget.dart';
import 'package:restaurant/responsive/functionsResponsive.dart';
import 'package:restaurant/scaffold/templates/layout/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/constants/assest_path.dart';
import 'package:restaurant/modules/report/report.dart';
import 'package:restaurant/themes/colors.dart';
//pages
import '../dashboard/Screen/dashboard_page.dart';
import '../orders/orders_page.dart';
import '../UserManage/myProfile_page.dart';
import '../categories/catetories_page.dart';
import '../policy/Privacy&Policy.dart';
import '../term/term&condition_page.dart';
import '../Authentication/providers/linkListener.dart';

class PageModel {
  String title;
  Widget icon;
  Widget page;
  PageModel({this.title, this.icon, this.page});
}

class LayoutExample extends StatefulWidget {
  static var routeName = "/home";

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
    // PageModel(
    //   title: "customers",
    //   icon: SizedBox(
    //     width: 25,
    //     height: 25,
    //     child: Image.asset(AssestPath.customerIcon, fit: BoxFit.cover),
    //   ),
    //   page: CustomersPage(),
    // ),
    // PageModel(
    //   title: "Resturants",
    //   icon: SizedBox(
    //     width: 25,
    //     height: 25,
    //     child: Image.asset(AssestPath.restaurantIcon, fit: BoxFit.cover),
    //   ),
    //   page: ResturantScreen(),
    // ),
    PageModel(
      title: "Orders",
      icon: Icon(Icons.room_service, color: AppColors.green),
      page: OrderPage(),
    ),
    PageModel(
      title: "My Profile",
      icon: Icon(Icons.account_circle_outlined, color: Colors.blue),
      page: ResturantForm(),
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
    // PageModel(
    //   title: "Coupons",
    //   icon: SizedBox(
    //     width: 25,
    //     height: 25,
    //     child: Image.asset(AssestPath.couponIcon, fit: BoxFit.cover),
    //   ),
    //   page: CouponsPage(),
    // ),
    // PageModel(
    //   title: "Notifications",
    //   icon: Icon(Icons.notifications_outlined, color: Colors.yellow),
    //   page: NotificationPage(),
    // ),
    PageModel(
      title: "Report",
      icon: Icon(Icons.report, color: Colors.yellow),
      page: ReportPage(),
    ),

    PageModel(
      title: "Notifications",
      icon: Image.asset("assets/images/notification.png"),
      page: NotificationPage(),
    ),
  ];

  int pageIndex = 0;

  @override
  void initState() {
    // initUniLinks(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return ResponsiveScaffold(
      kDesktopBreakpoint: 768,
      body: pages[pageIndex].page,
      drawerWidth: 200.0,
      drawer: SizedBox(
        width: 100,
        child: Column(
          children: [
            Visibility(
              visible: showAppBarNodepad(context),
              child: AppBar(
                centerTitle: true,
                title: Text("Menu"),
                leading: IconButton(
                  icon: new Icon(Icons.menu),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                // actions: [
                //   NotificationAppBarWidget(),
                // ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        ...pages.map((page) {
                          int index = pages.indexOf(page);

                          if (index == pages.length - 1) {
                            if (showAppBarNodepad(context)) {
                              return SizedBox();
                            }
                          }

                          return drawerListItemBuilder(
                            icon: page.icon,
                            title: page.title,
                            isActive: pageIndex == index,
                            onClick: () {
                              setState(() {
                                pageIndex = index;
                              });
                              if (showAppBarNodepad(context)) {
                                Navigator.pop(context);
                              }
                            },
                          );
                        }).toList(),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        AuthProvider().logOut(context);
                        Navigator.pushReplacementNamed(
                            context, LoginPage.routeName);
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout,
                              ),
                              SizedBox(width: 10),
                              Expanded(child: Text("Logout")),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
            Expanded(child: Text(title)),
          ],
        ),
      ),
    ),
  );
}
