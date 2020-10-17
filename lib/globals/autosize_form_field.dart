import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_size_text_field/auto_size_text_field.dart';

class AutoSizeFormField<T> extends FormField<String> {
  AutoSizeFormField({
    @required T Function(String) converter,
    String hintText,
    AutovalidateMode autovalidateMode = AutovalidateMode.always,
    TextDirection textDirection = TextDirection.rtl,
    TextEditingController controller,
    void Function(T) onChanged,
    void Function(T) onSaved,
    FocusNode focusNode,
    String Function(String) validator,
    TextInputType keyboardType,
    int maxLength,
    bool maxLengthEnforment,
    double minWidth,
  }) : super(
            autovalidateMode: autovalidateMode,
            onSaved: (value) => onSaved(converter(value)),
            builder: (FormFieldState<String> field) {
              void onChangedHandler(String value) {
                final v = converter(value);
                if (onChanged != null && v != null) {
                  onChanged(v);
                }
                field.didChange(value);
              }

              return AutoSizeTextField(
                fullwidth: false,
                maxLines: 1,
                focusNode: focusNode,
                onChanged: onChangedHandler,
                keyboardType: keyboardType,
                controller: controller,
                maxLength: maxLength,
                maxLengthEnforced: maxLengthEnforment,
                minWidth: minWidth,
              );
            });
}
