import 'package:restaurant/modules/customers/provider/customers_provider.dart';
import 'package:restaurant/modules/customers/widget/orderItem_widget.dart';
import 'package:restaurant/modules/notifications/notification_page.dart';
import 'package:restaurant/responsive/functionsResponsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//packages
import 'package:responsive_grid/responsive_grid.dart';
import 'package:restaurant/widgets/orderItem_widget.dart';
//widgets
import 'package:restaurant/widgets/commentItem_widget.dart';

class CustomerProfile extends StatefulWidget {
  static String routeName = 'CustomerProfile';
  final String id;
  CustomerProfile(this.id);
  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: .2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("Customer Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset("assets/images/notification.png"),
            onPressed: () {
              Navigator.pushNamed(context, NotificationPage.routeName);
            },
          )
        ],
      ),
      body: Consumer<CustomersProvider>(
          builder: (context, customerProvider, child) {
        return customerProvider.getCustomer != null
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        CircleAvatar(
                          radius: 40.0,
                          child: ClipRRect(
                            child: Image.network(
                                customerProvider.getCustomer.avatar),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(customerProvider.getCustomer.username,
                                  style: Theme.of(context).textTheme.headline4),
                              SizedBox(height: 5),
                              Text(customerProvider.getCustomer.email,
                                  style: TextStyle(color: Colors.black45)),
                              SizedBox(height: 5),
                              Text(
                                  "Total Orders :${customerProvider.getCustomer.totalOrder}",
                                  style: TextStyle(color: Colors.black45)),
                            ],
                          ),
                        ),
                      ]),
                      SizedBox(height: 20),
                      SizedBox(
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
                            "Orders",
                            style: Theme.of(context).textTheme.button,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      customerProvider.getOrders.length == 0
                          ? Card(
                              child: SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text("No Order"),
                                ),
                              ),
                            )
                          : ResponsiveGridRow(
                              children: [
                                ...List.generate(
                                    customerProvider.getOrders.length, (i) {
                                  return ResponsiveGridCol(
                                    xs: 12,
                                    sm: 12,
                                    md: 12,
                                    lg: 12,
                                    xl: 6,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: OrderCardItem(
                                          customerProvider.getOrders[i],
                                          'customeProfile'),
                                    ),
                                  );
                                }),
                              ],
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Reviews Shared",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 20),
                        ),
                      ),
                      customerProvider.getReview.length == 0
                          ? Card(
                              child: SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text("No Review"),
                                ),
                              ),
                            )
                          : ResponsiveGridRow(
                              children: [
                                ...List.generate(
                                    customerProvider.getReview.length, (i) {
                                  return ResponsiveGridCol(
                                    xs: 12,
                                    sm: 12,
                                    md: 12,
                                    lg: 6,
                                    xl: 6,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CommentItem(
                                          customerProvider.getReview[i]),
                                    ),
                                  );
                                }),
                              ],
                            ),
                    ],
                  ),
                ),
              )
            : FutureBuilder(
                future: customerProvider.fetchCustomer(widget.id),
                builder: (context, snapshot) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                });
      }),
    );
  }
}
