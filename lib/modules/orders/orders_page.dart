import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/themes/colors.dart';
import '../../widgets/orderItem_widget.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: TabBar(
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
        ),
        bottom: PreferredSize(preferredSize: Size(10, 10), child: Container()),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenSize > 1024 ? 2 : 1,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: ((MediaQuery.of(context).size.width) / 600),
            ),
            itemCount: 10,
            itemBuilder: (context, res) {
              return OrderItem();
            },
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenSize > 1024 ? 2 : 1,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: ((MediaQuery.of(context).size.width) / 600),
            ),
            itemCount: 10,
            itemBuilder: (context, res) {
              return OrderItem();
            },
          ),
          // SingleChildScrollView(
          //   child: Column(
          //     children: [
          //       OrderItem(),
          //       OrderItem(),
          //     ],
          //   ),
          // ),
          // SingleChildScrollView(
          //   child: Column(
          //     children: [
          //       OrderItem(),
          //       OrderItem(),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
