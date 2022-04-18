import 'package:flutter/material.dart';

import 'package:weekly_menu_app/widgets/recipe_view/number_text_field.dart';

import '../../models/enums/unit_of_measure.dart';

class UnitsOfMeasureDropdown extends StatefulWidget {
  UnitsOfMeasureDropdown();

  @override
  _UnitsOfMeasureDropdownState createState() => _UnitsOfMeasureDropdownState();
}

class _UnitsOfMeasureDropdownState extends State<UnitsOfMeasureDropdown> {
  String? _uomDropdownValue;
  double _spinnerValue = 0;

  DropdownMenuItem<String> _createDropDownItem(String uom) {
    return DropdownMenuItem<String>(
      child: Text(uom),
      value: uom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        NumberFormField(
          initialValue: _spinnerValue,
          labelText: 'Unità di misura',
          minValue: 0,
          maxValue: 9999,
          onChanged: (newValue) => _spinnerValue = newValue,
        ),
        DropdownButton<String>(
          value: _uomDropdownValue,
          items: UnitsOfMeasure.map((uom) => _createDropDownItem(uom)).toList(),
          onChanged: (s) => setState(() => _uomDropdownValue = s),
        ),
      ],
    );
  }
}
