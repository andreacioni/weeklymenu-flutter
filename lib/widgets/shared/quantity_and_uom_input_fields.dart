import 'package:flutter/material.dart';

import '../../models/enums/unit_of_measure.dart';
import 'number_text_field.dart';

class QuantityAndUnitOfMeasureInputFormField extends StatelessWidget {
  final String? unitOfMeasure;
  final double quantity;

  final void Function(double)? onQuantityChanged;
  final void Function(String?)? onUnitOfMeasureChanged;

  final void Function(double)? onQuantitySaved;
  final void Function(String?)? onUnitOfMeasureSaved;

  QuantityAndUnitOfMeasureInputFormField({
    this.unitOfMeasure,
    this.quantity = 0,
    this.onQuantityChanged,
    this.onUnitOfMeasureChanged,
    this.onQuantitySaved,
    this.onUnitOfMeasureSaved,
  });

  DropdownMenuItem<String> _createDropDownItem(String uom) {
    return DropdownMenuItem<String>(
      child: Text(uom),
      value: uom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Flexible(
          flex: 2,
          child: NumberFormField(
            initialValue: quantity.toDouble(),
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
          child: DropdownButtonFormField<String>(
            value: unitOfMeasure,
            hint: Text(
              'Unit',
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
            items:
                UnitsOfMeasure.map((uom) => _createDropDownItem(uom)).toList(),
            //can't use widget.onUnitOfMeasureChanged directly because DropdownButtonFormField needs
            //a non-null onChanged to be enabled
            onChanged: (value) {
              onUnitOfMeasureChanged?.call(value);
            },
            onSaved: onUnitOfMeasureSaved,
          ),
        ),
      ],
    );
  }
}
