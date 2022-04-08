import 'package:restaurant/modules/contactUs/model/contact_model.dart';
import 'package:restaurant/modules/contactUs/providers/contact_provider.dart';
import 'package:restaurant/modules/notifications/notification_page.dart';
import 'package:restaurant/responsive/functionsResponsive.dart';
import 'package:restaurant/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us Request"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset("assets/images/notification.png"),
            onPressed: () {
              Navigator.pushNamed(context, NotificationPage.routeName);
            },
          )
        ],
        leading: showAppBarNodepad(context)
            ? IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              )
            : null,
      ),
      body: Consumer<ContactProvider>(
        builder: (context, contactProvider, child) {
          return contactProvider.getContacts == null
              ? FutureBuilder(
                  future: contactProvider.fetchContacts(),
                  builder: (context, snapshot) {
                    return Center(child: CircularProgressIndicator());
                  })
              : contactProvider.getContacts!.isEmpty
                  ? Center(child: Text("No Contact us "))
                  : ListView.builder(
                      itemCount: contactProvider.getContacts!.length,
                      itemBuilder: (context, i) {
                        return _contactItemBuilder(
                          context,
                          contactProvider.getContacts![i],
                        );
                      },
                    );
        },
      ),
    );
  }
}

_contactItemBuilder(context, ContactModel contact) {
  return Card(
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${contact.username}",
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(height: 5),
          Text(
            "${contact.email}",
          ),
          SizedBox(height: 5),
          Text("${contact.restaurant}"),
          SizedBox(height: 5),
          Text("${contact.subject}"),
          SizedBox(height: 5),
          Text(
            "${contact.message}",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    ),
  );
}

// class ContactItem extends StatelessWidget {
//   final ContactModel contact;

//   ContactItem(this.contact);
//   @override
//   Widget build(BuildContext context) {
//     try {
//       return Card(
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 contact.username,
//                 style: Theme.of(context).textTheme.headline4,
//               ),
//               SizedBox(height: 5),
//               Text(contact.email),
//               SizedBox(height: 5),
//               Text(contact.restaurant),
//               SizedBox(height: 5),
//               Text(contact.subject),
//               SizedBox(height: 5),
//               Text(
//                 contact.message,
//                 style: TextStyle(color: Colors.black54),
//               ),
//             ],
//           ),
//         ),
//       );
//     } catch (e, s) {
//       print(contact.message);
//       return Text("Error Accured");
//     }
//   }
// }
