import 'package:flutter/material.dart';
import 'package:spinner_input/spinner_input.dart';

import '../../models/unit_of_measure.dart';

class UnitsOfMeasureDropdown extends StatefulWidget {

  UnitsOfMeasureDropdown();

  @override
  _UnitsOfMeasureDropdownState createState() => _UnitsOfMeasureDropdownState();
}

class _UnitsOfMeasureDropdownState extends State<UnitsOfMeasureDropdown> {
  
  UnitOfMeasure _dropdownValue;
  double _spinnerValue = 0;

  DropdownMenuItem<UnitOfMeasure> _createDropDownItem(UnitOfMeasure uom) {
    return DropdownMenuItem<UnitOfMeasure>(
      child: Text(uom.name), 
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
        DropdownButton<UnitOfMeasure>(
          value: _dropdownValue,
          items: unitsOfMeasure.map((uom) => _createDropDownItem(uom)).toList(),
          onChanged: (s) {
            setState(() {
              _dropdownValue = s;
            });
          },
        ),
      ],
    );
  }
}