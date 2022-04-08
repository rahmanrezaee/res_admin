import 'package:flutter/material.dart';

class DropDownFormField extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final bool required;
  final String ?errorText;
  final dynamic value;
  final padding;
  final List ?dataSource;
  final String? textField;
  final String ?valueField;

  final Function? onChanged;
  final bool filled;
  final bool enable;

  DropDownFormField(
      {FormFieldSetter<dynamic> ?onSaved,
      FormFieldValidator<dynamic>? validator,
      bool autovalidate = false,
      this.titleText = 'Title',
      this.hintText = 'Select one option',
      this.required = false,
      this.errorText,
      this.value,
      this.dataSource,
      this.textField,
      this.padding,
      this.valueField,
      this.onChanged,
      this.enable = true,
      this.filled = true})
      : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: value == '' ? null : value,
          builder: (FormFieldState<dynamic> state) {
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
              child: InputDecorator(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 32.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 32.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Column(
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton<dynamic>(
                        isDense: false,
                        itemHeight: 50,
                        isExpanded: true,
                        hint: Text(
                          "$hintText",
                          style: TextStyle(color: Colors.grey),
                        ),
                        value: value,
                        onChanged: enable
                            ? (dynamic newValue) {
                                state.didChange(newValue);

                                onChanged!(newValue);
                              }
                            : null,
                        items: dataSource!.map((item) {
                          return DropdownMenuItem<dynamic>(
                            value: item[valueField],
                            child: Text(
                              item[textField],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                   
                  ],
                ),
              ),
            );
          },
        );
}
