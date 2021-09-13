import 'package:cached_network_image/cached_network_image.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:restaurant/modules/notifications/models/notification_model.dart';
import 'package:restaurant/modules/notifications/provider/notificaction_provider.dart';
import 'package:restaurant/modules/orders/orders_page.dart';
import 'package:restaurant/modules/orders/orders_page_notification.dart';
import 'package:restaurant/responsive/functionsResponsive.dart';
import 'package:restaurant/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import 'notification_details.dart';

class NotificationPage extends StatelessWidget {
  static String routeName = "Notification";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBarNodepad(context)
          ? AppBar(
              title: Text("Notifications"),
              centerTitle: true,
              actions: [
                IconButton(
                    icon: Icon(Icons.delete_outline_outlined),
                    onPressed: () {
                      Provider.of<NotificationProvider>(context, listen: false)
                          .clearAll();
                    })
              ],
            )
          : PreferredSize(
              preferredSize: Size(10, 20),
              child: SizedBox(
                height: 60,
              )),
      body: Consumer<NotificationProvider>(
        builder: (BuildContext context, value, Widget child) {
          return value.notificatins == null
              ? FutureBuilder(
                 
                  builder: (context, snapshot) {
                    return Center(child: CircularProgressIndicator());
                  })
              : RefreshIndicator(
                  onRefresh: () async {
                    return value.fetchNotifications(pageParams: 1);
                  },
                  child: value.notificatins.isEmpty
                      ? Center(child: Text("No Notification"))
                      : IncrementallyLoadingListView(
                          hasMore: () => value.hasMoreItems,
                          itemCount: () => value.notificatins.length,
                          loadMore: () async {
                            await value.fetchNotifications();
                          },
                          onLoadMore: () {
                            value.showLoadingBottom(true);
                          },
                          onLoadMoreFinished: () {
                            value.showLoadingBottom(false);
                          },
                          loadMoreOffsetFromBottom: 0,
                          itemBuilder: (context, index) {
                            if ((value.loadingMore ?? false) &&
                                index == value.notificatins.length - 1) {
                              return Column(
                                children: <Widget>[
                                  NotificationItem(value.notificatins[index]),
                                  PlaceholderItemCard()
                                ],
                              );
                            }
                            return NotificationItem(value.notificatins[index]);
                          },
                        ),
                );
        },
      ),
    );
  }
}

class PlaceholderItemCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}

class NotificationItem extends StatefulWidget {
  final NotificationModel notification;

  NotificationItem(this.notification);

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Card(
      color: widget.notification.status == "onWrite"
          ? Colors.grey[300]
          : Colors.white,
      child: InkWell(
        onTap: () {
          if (widget.notification.status == "onWrite") {
            setState(() {
              widget.notification.status = "write";
            });
            Provider.of<NotificationProvider>(context, listen: false)
                .notificationChangeState(widget.notification.id);
          }

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OrdersPageNotification()));
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/images/desk-bell.png",
                    fit: BoxFit.cover,
                  ),
                ),

                //  Image.network(
                //   widget.notification.image,
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("${widget.notification.body}"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        '${Jiffy(widget.notification.createdAt).format("h:mm a / MM.dd.yyyy")}',
                        style: TextStyle(fontWeight: FontWeight.w300)),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      elevation: 3,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
