import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  static String routeName = "Notification";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, i) {
          return NotificationItem();
        },
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(children: [
          SizedBox(
            width: 75,
            height: 75,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                'https://www.fremontafghankabob.com/wp-content/uploads/2017/10/Bobak-Radbin-FremontAfghanKabob-49-938x699.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Text(
                    "Eliot. Pretium, duis consequat cras id. Nisi, fames etiam quisque ipsum vitae neque fringilla quis."),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("10:33 AM / 08.02.2021",
                      style: TextStyle(fontWeight: FontWeight.w300)),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
