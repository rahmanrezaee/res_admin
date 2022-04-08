
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../notification_page.dart';
import '../provider/notificaction_provider.dart';

class NotificationAppBarWidget extends StatelessWidget {
  static final routeName = "notificationappbarwidget";
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(builder: (context, data, snapshot) {
      print(" data.countNotification ${data.countNotification}");
      return Container(
        margin: EdgeInsets.only(right: 10, left: 10),
        child: IconButton(
            icon: Badge(
                animationType: BadgeAnimationType.scale,
                badgeContent: data.notificatins == null
                    ? FutureBuilder(
                        future: data.fetchNotifications(),
                        builder: (context, snapshot) {
                          return Text(
                            '0',
                            style: TextStyle(color: Colors.white),
                          );
                        })
                    : Text(
                        '${data.onWriteNotification}',
                        style: TextStyle(color: Colors.white),
                      ),
                child: Icon(
                  FontAwesomeIcons.bell,
                )),
            onPressed: () {
              Navigator.pushNamed(context, NotificationPage.routeName);
            }),
      );
    });
  }
}
