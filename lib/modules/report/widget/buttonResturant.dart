import 'package:flutter/material.dart';

class ButtonRaiseResturant extends StatelessWidget {
  Function onPress;
  String label;
  Color color;

  ButtonRaiseResturant({this.color, this.label, this.onPress});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      color: this.color,
      child: Text(
        this.label,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
      ),
      onPressed: this.onPress,
    );
  }
}
