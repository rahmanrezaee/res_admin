import 'package:flutter/material.dart';

//packages
import 'package:responsive_grid/responsive_grid.dart';
import 'package:restaurant/widgets/orderItem_widget.dart';
//widgets
import 'package:restaurant/widgets/commentItem_widget.dart';

class CustomerProfile extends StatefulWidget {
  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(
                radius: 40.0,
                child: ClipRRect(
                  child: Image.network('https://i.pravatar.cc/300'),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rahman Rezaiee",
                      style: Theme.of(context).textTheme.headline4),
                  SizedBox(height: 5),
                  Text("johndoe2021@gmail.com",
                      style: TextStyle(color: Colors.black45)),
                  Text("Total Order Placed",
                      style: TextStyle(color: Colors.black45)),
                ],
              ),
            ]),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
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
            ResponsiveGridRow(
              children: [
                ...List.generate(2, (i) {
                  return ResponsiveGridCol(
                    xs: 12,
                    sm: 12,
                    md: 12,
                    lg: 12,
                    xl: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OrderItem(),
                    ),
                  );
                }),
              ],
            ),
            Text(
              "Reviews Shared",
              style:
                  Theme.of(context).textTheme.headline4.copyWith(fontSize: 20),
            ),
            ResponsiveGridRow(
              children: [
                ...List.generate(2, (i) {
                  return ResponsiveGridCol(
                    xs: 12,
                    sm: 12,
                    md: 12,
                    lg: 6,
                    xl: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CommentItem(),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
