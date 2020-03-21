import 'package:flutter/material.dart';
import 'package:spinner_input/spinner_input.dart';

import '../../models/enums/unit_of_measure.dart';

class UnitsOfMeasureDropdown extends StatefulWidget {

  UnitsOfMeasureDropdown();

  @override
  _UnitsOfMeasureDropdownState createState() => _UnitsOfMeasureDropdownState();
}

class _UnitsOfMeasureDropdownState extends State<UnitsOfMeasureDropdown> {
  
  String _uomDropdownValue;
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
        SpinnerInput(
            spinnerValue: _spinnerValue,
            fractionDigits: 0,
            disabledPopup: true,
            minValue: 0,
            maxValue: 9999,
            step: 1,
            onChange: (newValue) {
              _spinnerValue = newValue;
            },
          ),
        DropdownButton<String>(
          value: _uomDropdownValue,
          items: UnitsOfMeasure.map((uom) => _createDropDownItem(uom)).toList(),
          onChanged: (s) {
            setState(() {
              _uomDropdownValue = s;
            });
          },
        ),
      ],
    );
  }
}