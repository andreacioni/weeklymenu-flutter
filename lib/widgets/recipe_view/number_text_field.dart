import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weekly_menu_app/globals/autosize_form_field.dart';

class NumberFormField extends StatefulWidget {
  final String hintText;
  final double minValue;
  final double maxValue;
  final double initialValue;
  final bool allowEmpty;
  final int fractionDigits;
  final void Function(double) onChanged;
  final void Function(double) onSaved;

  NumberFormField({
    this.initialValue,
    this.hintText,
    this.minValue = 0,
    this.maxValue = 10000,
    this.allowEmpty = true,
    this.fractionDigits = 0,
    this.onChanged,
    this.onSaved,
  });

  @override
  _NumberFormFieldState createState() => _NumberFormFieldState();
}

class _NumberFormFieldState extends State<NumberFormField> {
  TextEditingController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    _controller = new TextEditingController(
        text: widget.initialValue?.toStringAsFixed(widget.fractionDigits));
    _focusNode = new FocusNode();

    _focusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutoSizeFormField<double>(
      converter: (value) =>
          value != null && value.isNotEmpty ? double.tryParse(value) : null,
      keyboardType: TextInputType.number,
      maxLength: 5,
      maxLengthEnforment: true,
      minWidth: 20,
      controller: _controller,
      focusNode: _focusNode,
      validator: _validateNumber,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      textDirection: TextDirection.rtl,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9\.,]"))],
      decoration: InputDecoration(counterText: "", errorText: null),
    );
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
    }
  }

  String _validateNumber(String value) {
    if (widget.allowEmpty && value == null)
      return null;
    else if (value == null) return "Invalid number";

    var number = double.tryParse(value);

    if (number == null) return "Not a number";

    if (number < widget.minValue) return "Value is too low";

    if (number > widget.maxValue) return "Value too high";

    return null;
  }

  @override
  void dispose() {
    _focusNode?.removeListener(_onFocusChange);
    _focusNode?.dispose();
    _focusNode = null;

    _controller?.dispose();
    _controller = null;

    super.dispose();
  }
}
