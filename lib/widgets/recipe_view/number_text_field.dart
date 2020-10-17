import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weekly_menu_app/globals/autosize_form_field.dart';

class NumberTextFormField extends StatefulWidget {
  final String hintText;
  final AutovalidateMode autovalidateMode;
  final TextDirection textDirection;
  final TextEditingController controller;
  final double minValue;
  final double maxValue;
  final double initialValue;
  final bool allowEmpty;
  final int fractionDigits;
  final void Function(double) onChanged;
  final void Function(double) onSaved;
  final String Function(double) validator;

  NumberTextFormField({
    this.initialValue,
    this.hintText,
    this.autovalidateMode = AutovalidateMode.always,
    this.textDirection = TextDirection.rtl,
    this.controller,
    this.minValue = 0,
    this.maxValue = 10000,
    this.allowEmpty = true,
    this.fractionDigits = 0,
    this.onChanged,
    this.onSaved,
    this.validator,
  });

  @override
  _NumberTextFormFieldState createState() => _NumberTextFormFieldState();
}

class _NumberTextFormFieldState extends State<NumberTextFormField> {
  TextEditingController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    _controller = new TextEditingController(
        text: widget.initialValue?.toStringAsFixed(widget.fractionDigits));
    _focusNode = new FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutoSizeFormField<double>(
      converter: (value) => double.tryParse(value),
      keyboardType: TextInputType.number,
      maxLength: 5,
      maxLengthEnforment: true,
      minWidth: 20,
      controller: _controller,
      focusNode: _focusNode,
      validator: validateNumber,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
    );
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _focusNode = null;

    _controller.dispose();
    _controller = null;

    super.dispose();
  }

  String validateNumber(String value) {
    if (widget.allowEmpty && value == null)
      return null;
    else if (value == null) return "Invalid number";

    var number;

    number = double.tryParse(value);

    if (number == null) return "Not a number";

    if (number < widget.minValue) return "Value is too low";

    if (number > widget.maxValue) return "Value too high";

    return null;
  }
}
