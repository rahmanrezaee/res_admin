import 'package:flutter/material.dart';

class AdaptiveAppBar extends StatelessWidget {
  AdaptiveAppBar(this.appBar);
  final Widget appBar;
  @override
  Widget build(BuildContext context) {}
}

adaptiveAppBarBuilder(BuildContext context, Widget appBar) {
  double screenSize = MediaQuery.of(context).size.width;
  return screenSize < 768
      ? PreferredSize(
          preferredSize: Size(double.infinity, AppBar().preferredSize.height),
          child: appBar,
        )
      : PreferredSize(
          preferredSize: Size(0, 0),
          child: Container(),
        );
}
