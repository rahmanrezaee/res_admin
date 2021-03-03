import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//packages
import 'package:responsive_grid/responsive_grid.dart';
import 'package:restaurant/widgets/orderItem_widget.dart';
//widgets
import 'package:restaurant/widgets/commentItem_widget.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool openForOrder = false;
  bool autoAcceptOrder = true;

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
              SizedBox(width: 20),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Open for Orders",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                CupertinoSwitch(
                  value: openForOrder,
                  onChanged: (value) {
                    setState(() {
                      openForOrder = value;
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
                Text("Auto Accept Order",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                CupertinoSwitch(
                  value: autoAcceptOrder,
                  onChanged: (value) {
                    setState(() {
                      autoAcceptOrder = value;
                    });
                  },
                  // trackColor: AppColors.green,
                ),
              ],
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 300,
                height: 40,
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Change Password",
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Timings",
                            style: Theme.of(context).textTheme.headline6),
                        Text("Open",
                            style: Theme.of(context).textTheme.headline6),
                        Text("Close",
                            style: Theme.of(context).textTheme.headline6),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    timelineItemBuilder(),
                    timelineItemBuilder(),
                    timelineItemBuilder(),
                    timelineItemBuilder(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row timelineItemBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("MONDAY"),
        Row(
          children: [
            Text("09:00"),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
          ],
        ),
        Row(
          children: [
            Text("09:00"),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
