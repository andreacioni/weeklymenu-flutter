import 'package:flutter/material.dart';
import 'package:spinner_input/spinner_input.dart';

import '../../../presentation/custom_icons_icons.dart';
import '../../../dummy_data.dart';
import '../../../models/unit_of_measure.dart';

import '../unit_of_measure_dropdown.dart';

class AddIngredientModal extends StatefulWidget {
  @override
  _AddIngredientModalState createState() => _AddIngredientModalState();
}

class _AddIngredientModalState extends State<AddIngredientModal> {
  UnitOfMeasure _dropdownValue;
  double _spinnerValue = 0;
  bool _isFreezed = false;

  DropdownMenuItem<UnitOfMeasure> _createDropDownItem(UnitOfMeasure uom) {
    return DropdownMenuItem<UnitOfMeasure>(
      child: Text(uom.name),
      value: uom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              //RecipeSelectionTextField([], onSelected: () {}),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SpinnerInput(
                    spinnerValue: _spinnerValue,
                    fractionDigits: 0,
                    minValue: 0,
                    maxValue: 9999,
                    step: 1,
                    onChange: (newValue) {
                      setState(() {
                        _spinnerValue = newValue;
                      });
                    },
                  ),
                  DropdownButton<UnitOfMeasure>(
                    value: _dropdownValue,
                    items: unitsOfMeasure
                        .map((uom) => _createDropDownItem(uom))
                        .toList(),
                    onChanged: (s) {
                      setState(() {
                        _dropdownValue = s;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        CustomIcons.ac_unit,
                        color: Colors.lightBlue,
                        size: 30,
                      ),
                      Text(
                        "Freezed",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Switch(
                      value: _isFreezed,
                      onChanged: (newValue) {
                        setState(() {
                          _isFreezed = newValue;
                        });
                      }),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text("CANCEL"),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  FlatButton(
                    child: Text("ADD"),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
