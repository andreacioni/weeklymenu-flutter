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
    List<TextInputFormatter> inputFormatters,
    InputDecoration decoration,
  }) : super(
            autovalidateMode: autovalidateMode,
            validator: validator,
            onSaved:
                onSaved != null ? (value) => onSaved(converter(value)) : null,
            builder: (FormFieldState<String> field) {
              final InputDecoration effectiveDecoration = (decoration ??
                      const InputDecoration())
                  .applyDefaults(Theme.of(field.context).inputDecorationTheme);
              void onChangedHandler(String value) {
                final v = converter(value);
                if (onChanged != null && v != null) {
                  onChanged(v);
                }
                field.didChange(value);
              }

              return AutoSizeTextField(
                controller: controller,
                decoration:
                    effectiveDecoration.copyWith(errorText: field.errorText),
                fullwidth: false,
                maxLines: 1,
                focusNode: focusNode,
                onChanged: onChangedHandler,
                keyboardType: keyboardType,
                maxLength: maxLength,
                maxLengthEnforced: maxLengthEnforment,
                minWidth: minWidth,
                inputFormatters: inputFormatters,
              );
            });
}
