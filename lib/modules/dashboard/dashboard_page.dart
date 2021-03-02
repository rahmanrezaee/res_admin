import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/themes/colors.dart';
//widgets
import '../../widgets/appbar_widget.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool openForOrder = true;
  bool autoAcceptOrder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adaptiveAppBarBuilder(
        context,
        AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Open for Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
              Text("Auto Accept Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 350,
                height: 50,
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "15 Active Orders",
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 10),
              Text("Total earning Today: \$XX.XX",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))
            ],
          )
        ],
      ),
    );
  }
}
