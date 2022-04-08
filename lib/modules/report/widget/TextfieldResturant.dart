import 'dart:ui';

import 'package:flutter/material.dart';

class TextFormFieldResturant extends StatelessWidget {
  String? hintText;
  TextEditingController? controller;
  Function(String)? onChange;
  void Function()? onTap;
  Function(String?)? onSave;
  String? Function(String?)? valide;
  String? initValue;
  String? perfixText;
  bool? enable;
  IconData? icon;
  TextInputType? typetext;
  TextFormFieldResturant(
      {this.hintText,
      this.controller,
      this.onChange,
      this.onSave,
      this.initValue,
      this.perfixText,
      this.onTap,
      this.typetext = TextInputType.text,
      this.enable = false,
      this.valide,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: TextFormField(
        keyboardType: this.typetext,
        controller: controller,
        onChanged: this.onChange,
        onSaved: this.onSave,
        initialValue: this.initValue,
        readOnly: enable!,
        onTap: onTap,
        validator: this.valide,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15.0, 15, 15.0, 0),
          hintText: hintText,
          suffixIcon: Icon(this.icon),
          prefixText: perfixText,
          errorStyle: TextStyle(color: Colors.red, height: 1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.white, width: 32.0),
          //   borderRadius: BorderRadius.circular(10.0),
          // ),
        ),
      ),
    );
  }
}
