import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/user_preferences.dart';

class QuantityAndUnitOfMeasureInputFormField extends HookConsumerWidget {
  final String? unitOfMeasure;
  final double? quantity;

  final void Function(double?)? onQuantityChanged;
  final void Function(String?)? onUnitOfMeasureChanged;

  final void Function(double?)? onQuantitySaved;
  final void Function(String?)? onUnitOfMeasureSaved;

  QuantityAndUnitOfMeasureInputFormField(
      {this.unitOfMeasure,
      this.quantity,
      this.onQuantityChanged,
      this.onUnitOfMeasureChanged,
      this.onQuantitySaved,
      this.onUnitOfMeasureSaved});

  DropdownMenuItem<String> _createDropDownItem(String? uom) {
    return DropdownMenuItem<String>(
      child: Text(uom ?? ''),
      value: uom,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitOfMeasures = ref.watch(unitOfMeasuresProvider);

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 2,
          child: NullableNumberFormField(
            initialValue: quantity,
            fractionDigits: 1,
            minValue: 0,
            maxValue: 9999,
            onChanged: onQuantityChanged,
            labelText: "Quantity",
            hintText: 'Quantity',
            onSaved: onQuantitySaved,
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(
            width: 10,
          ),
        ),
        Flexible(
          flex: 1,
          child: Autocomplete<String>(
            initialValue: TextEditingValue(text: unitOfMeasure ?? ''),
            fieldViewBuilder:
                ((context, textEditingController, focusNode, onFieldSubmitted) {
              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                onChanged: (value) {
                  onUnitOfMeasureChanged?.call(value);
                },
                onSaved: onUnitOfMeasureSaved,
                decoration: InputDecoration(hintText: 'Unit'),
              );
            }),
            optionsBuilder: (text) => unitOfMeasures.where((u) => u
                .toLowerCase()
                .trim()
                .startsWith(text.text.toLowerCase().trim())),
          ),
        ),
      ],
    );
  }
}

class NullableNumberFormField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final double minValue;
  final double maxValue;
  final double? initialValue;
  final bool allowEmpty;
  final int fractionDigits;
  final void Function(double?)? onChanged;
  final void Function(double?)? onSaved;

  NullableNumberFormField({
    this.initialValue,
    required this.labelText,
    String? hintText,
    this.minValue = 0,
    this.maxValue = 10000,
    this.allowEmpty = true,
    this.fractionDigits = 0,
    this.onChanged,
    this.onSaved,
  }) : this.hintText = hintText ?? labelText;

  @override
  _NullableNumberFormFieldState createState() =>
      _NullableNumberFormFieldState();
}

class _NullableNumberFormFieldState extends State<NullableNumberFormField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

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
          hintText: widget.hintText,
          labelText: widget.labelText,
        ),
        controller: _controller,
        focusNode: _focusNode,
        validator: _validateNumber,
        onChanged: widget.onChanged != null ? (v) => _onChanged(v) : null,
        onSaved: widget.onSaved != null ? (v) => _onSaved(v) : null,
        maxLines: 1,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9\.,]"))
        ]);
  }

  void _onChanged(String v) {
    final value = double.tryParse(v);
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  void _onSaved(String? v) {
    if (v != null && widget.onSaved != null) {
      final value = double.tryParse(v);

      widget.onSaved!(value);
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
    }
  }

  String? _validateNumber(String? value) {
    if (widget.allowEmpty && (value == null || value.isEmpty))
      return null;
    else if (value == null) return "Invalid number";

    var number = double.tryParse(value);

    if (number == null || number.isNaN) return "Not a number";

    if (number < widget.minValue) return "Value is too low";

    if (number > widget.maxValue) return "Value too high";

    return null;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();

    _controller.dispose();

    super.dispose();
  }
}
