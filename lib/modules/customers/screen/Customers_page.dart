import 'package:restaurant/modules/notifications/notification_page.dart';
import 'package:restaurant/responsive/functionsResponsive.dart';
import 'package:restaurant/widgets/appbar_widget.dart';
import 'package:restaurant/widgets/fancy_dialog.dart';
import 'package:flutter/services.dart';

import './customerProfile.dart';
import 'package:restaurant/modules/customers/provider/customers_provider.dart';
import 'package:restaurant/themes/colors.dart';
import 'package:restaurant/themes/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//models
import '../models/customer_model.dart';

class CustomersPage extends StatefulWidget {
  static String routeName = "CustomersPage";

  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        CustomerProfile.routeName: (context) =>
            CustomerProfile(ModalRoute.of(context).settings.arguments),
      },
      debugShowCheckedModeBanner: false,
      theme: restaurantTheme,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Manage Customers"),
          centerTitle: true,
          leading: showAppBarNodepad(context)
              ? IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                )
              : null,
          actions: [
            IconButton(
              icon: Image.asset("assets/images/notification.png"),
              onPressed: () {
                Navigator.pushNamed(context, NotificationPage.routeName);
              },
            )
          ],
          bottom: isLoading
              ? PreferredSize(
                  preferredSize: Size(10, 10),
                  child: LinearProgressIndicator(),
                )
              : null,
        ),
        body: Consumer<CustomersProvider>(
            builder: (context, customersProvider, child) {
          if (customersProvider.getCustomers == null) {
            customersProvider.fetchCustomers();

            return Center(child: CircularProgressIndicator());
          } else if (customersProvider.getCustomers.length < 1) {
            return Center(
              child: Text(
                "The customer list is empty",
                style: TextStyle(color: Colors.black),
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: customersProvider.getCustomers.length,
                    itemBuilder: (context, i) {
                      return _customerItemBuilder(
                        context,
                        customersProvider.getCustomers[i],
                        customersProvider,
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  _customerItemBuilder(
      context, Customer customer, CustomersProvider customersProvider) {
    return InkWell(
      onTap: () {
        print("this is the customer: ${customer.id}");
        Navigator.of(context)
            .pushNamed(CustomerProfile.routeName, arguments: customer.id);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                customer.username,
                style: Theme.of(context).textTheme.headline4,
              ),
              Text("${customer.activeOrders} Active Orders",
                  style: TextStyle(color: Colors.grey)),
              Row(
                children: [
                  // IconButton(
                  //   icon: Icon(Icons.room_service, color: AppColors.green),
                  //   onPressed: () {},
                  // ),
                  SizedBox(width: 5),
                  // IconButton(
                  //   icon: Icon(Icons.edit, color: AppColors.green),
                  //   onPressed: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return SimpleDialog(
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           title: Text("Add/Edit Category",
                  //               style: TextStyle(
                  //                   fontSize: 14, fontWeight: FontWeight.bold),
                  //               textAlign: TextAlign.center),
                  //           contentPadding: EdgeInsets.symmetric(
                  //               horizontal: 35, vertical: 25),
                  //           children: [
                  //             Divider(),
                  //             TextField(
                  //               // minLines: 6,
                  //               // maxLines: 6,
                  //               decoration: InputDecoration(
                  //                 hintText: "Enter here",
                  //                 hintStyle: TextStyle(color: Colors.grey),
                  //                 contentPadding:
                  //                     EdgeInsets.only(left: 10, top: 15),
                  //                 enabledBorder: OutlineInputBorder(
                  //                   borderRadius:
                  //                       BorderRadius.all(Radius.circular(10.0)),
                  //                   borderSide: BorderSide(color: Colors.grey),
                  //                 ),
                  //                 focusedBorder: OutlineInputBorder(
                  //                   borderRadius:
                  //                       BorderRadius.all(Radius.circular(10.0)),
                  //                   borderSide: BorderSide(color: Colors.grey),
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(height: 10),
                  //             SizedBox(
                  //               width: MediaQuery.of(context).size.width,
                  //               child: RaisedButton(
                  //                 padding: EdgeInsets.symmetric(vertical: 10),
                  //                 color: Theme.of(context).primaryColor,
                  //                 elevation: 0,
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(8),
                  //                 ),
                  //                 child: Text(
                  //                   "Save",
                  //                   style: Theme.of(context).textTheme.button,
                  //                 ),
                  //                 onPressed: () {
                  //                   Navigator.of(context).pop();
                  //                 },
                  //               ),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   },
                  // ),
                  // SizedBox(width: 5),
                  IconButton(
                    icon: Image.asset("assets/images/delete.png"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => FancyDialog(
                                title: "Delete Customer!",
                                okFun: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Provider.of<CustomersProvider>(context,
                                          listen: false)
                                      .deleteCustomer(customer.id)
                                      .then((res) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    // ScaffoldMessenger.of(context)
                                    //     .hideCurrentSnackBar();
                                    if (res == true) {
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(new SnackBar(
                                      //   content: Text(
                                      //       "The user deleted Successfuly."),
                                      // ));
                                    } else {
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(new SnackBar(
                                      //   content: Text(
                                      //     "Something went wrong while deleting customer.",
                                      //     style: TextStyle(
                                      //         color: AppColors.redText),
                                      //   ),
                                      // ));
                                    }
                                  });
                                },
                                cancelFun: () {},
                                descreption: "Are You Sure To Delete Customer?",
                              ));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
