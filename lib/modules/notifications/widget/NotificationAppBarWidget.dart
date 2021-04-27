import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/modules/notifications/notification_page.dart';
import 'package:restaurant/modules/notifications/provider/notificaction_provider.dart';

class NotificationAppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(builder: (context, data, snapshot) {
      print(" data.countNotification ${data.countNotification}");
      return new Stack(
        children: <Widget>[
          new IconButton(
              icon: Image.asset("assets/images/notification.png"),
              onPressed: () {
                Navigator.pushNamed(context, NotificationPage.routeName);
              }),
          data.notificatins == null
              ? FutureBuilder(
                  future: data.fetchNotifications(),
                  builder: (context, snapshot) {
                    return Container();
                  })
              : new Positioned(
                  right: 11,
                  top: 11,
                  child: new Container(
                    padding: EdgeInsets.all(2),
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '${data.onWriteNotification}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
        ],
      );
    });
  }
}
