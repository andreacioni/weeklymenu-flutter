import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberFormField extends StatefulWidget {
  final String hintText;
  final String labelText;
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
    this.labelText,
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
    return TextFormField(
        decoration: InputDecoration(
            hintText: widget.hintText, labelText: widget.labelText),
        controller: _controller,
        focusNode: _focusNode,
        validator: _validateNumber,
        onChanged: (v) => widget.onChanged(double.tryParse(v)),
        onSaved: (v) => widget.onSaved(double.tryParse(v)),
        maxLines: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9\.,]"))
        ]);
    /* return AutoSizeFormField<double>(
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
    ); */
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
    }
  }

  String _validateNumber(String value) {
    if (widget.allowEmpty && (value == null || value.isEmpty))
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
