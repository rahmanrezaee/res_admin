import 'package:flutter/material.dart';

class DropDownFormField extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  final padding;
  final List dataSource;
  final String textField;
  final String valueField;

  final Function onChanged;
  final bool filled;
  final bool enable;

  DropDownFormField(
      {FormFieldSetter<dynamic> onSaved,
      FormFieldValidator<dynamic> validator,
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
          autovalidate: autovalidate,
          initialValue: value == '' ? null : value,
          builder: (FormFieldState<dynamic> state) {
            return InputDecorator(
              decoration: InputDecoration(
                errorText: errorText,
                contentPadding: padding != null
                    ? padding
                    : const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 10,
                      ),
                // disabledBorder: InputBorder.none,
                // border: ,
                // focusedBorder: InputBorder.none,
                // enabledBorder: InputBorder.none,
                // errorBorder: InputBorder.none,
              ),
              child: DropdownButtonHideUnderline(
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

                          onChanged(newValue);
                        }
                      : null,
                  items: dataSource.map((item) {
                    return DropdownMenuItem<dynamic>(
                      value: item[valueField],
                      child: Text(
                        item[textField],
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
}
