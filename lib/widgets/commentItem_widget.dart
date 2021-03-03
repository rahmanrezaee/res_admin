import 'package:flutter/material.dart';
//pacakges
import 'package:smooth_star_rating/smooth_star_rating.dart';

class CommentItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
                ),
                title: Text(
                  "Ali Azad",
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("08.02.2021"),
                    SizedBox(height: 5),
                    SmoothStarRating(
                        allowHalfRating: false,
                        onRated: (v) {},
                        starCount: 5,
                        rating: 4,
                        size: 20.0,
                        isReadOnly: true,
                        color: Theme.of(context).primaryColor,
                        borderColor: Theme.of(context).primaryColor,
                        spacing: 0.0)
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                  "Vulputate vel molestie morbi mollis lacinia aenean. Pellentesque egestas vulputate odio faucibus sit non, tellus a. Vulputate tellus mattis morbi urna mus ut sed bibendum. Suscipit at elit netus vitae nec. Velit adipiscing at sit sagittis, sollicitudin luctus fringilla amet velit.",
                  style: TextStyle(height: 1.3)),
            ],
          ),
        ));
  }
}
