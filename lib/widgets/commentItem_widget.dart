import 'package:restaurant/modules/customers/models/review_model.dart';
import 'package:flutter/material.dart';
//pacakges
import 'package:smooth_star_rating/smooth_star_rating.dart';

class CommentItem extends StatelessWidget {
  final ReviewModel review;
  CommentItem(this.review);
  @override
  Widget build(BuildContext context) {
    try {
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
                    backgroundImage:
                        NetworkImage(review.userId.avatar['uriPath']),
                  ),
                  title: Text(
                    review.userId.username,
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(review.date),
                      SizedBox(height: 5),
                      SmoothStarRating(
                        allowHalfRating: false,
                        onRated: (v) {},
                        starCount: review.rate,
                        rating: 4,
                        size: 20.0,
                        isReadOnly: true,
                        color: Theme.of(context).primaryColor,
                        borderColor: Theme.of(context).primaryColor,
                        spacing: 0.0,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  review.message,
                  style: TextStyle(height: 1.3),
                ),
              ],
            ),
          ));
    } catch (e, s) {
      print(s);
    }
  }
}
