import 'package:flutter/material.dart';

class LabelDashBoard extends StatelessWidget {
  String title;
  double fontSize;
  Color color;
  Color textColor;

  LabelDashBoard({this.color, this.fontSize, this.title, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text("${this.title}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: this.textColor,
                      fontSize: this.fontSize != null ? this.fontSize : 18,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ],
    );
  }
}
