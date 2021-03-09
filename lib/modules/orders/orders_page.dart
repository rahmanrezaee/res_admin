import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/themes/colors.dart';
import '../../widgets/orderItem_widget.dart';

//
import 'package:responsive_grid/responsive_grid.dart';

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
          SingleChildScrollView(
            child: Column(
              children: [
                ResponsiveGridRow(
                  children: [
                    ...List.generate(6, (i) {
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
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                ResponsiveGridRow(
                  children: [
                    ...List.generate(6, (i) {
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
              ],
            ),
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
