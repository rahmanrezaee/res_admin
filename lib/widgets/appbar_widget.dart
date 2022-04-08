import 'package:flutter/material.dart';


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
