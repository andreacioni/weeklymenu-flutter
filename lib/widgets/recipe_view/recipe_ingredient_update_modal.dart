import 'package:flutter/material.dart';
import 'package:spinner_input/spinner_input.dart';
import 'package:weekly_menu_app/models/unit_of_measure.dart';

import '../../models/ingredient.dart';
import '../../models/unit_of_measure.dart';

class RecipeIngredientUpdateModal extends StatefulWidget {
  final RecipeIngredient _recipeIngredient;

  RecipeIngredientUpdateModal(this._recipeIngredient);

  @override
  _RecipeIngredientUpdateModalState createState() =>
      _RecipeIngredientUpdateModalState();
}

class _RecipeIngredientUpdateModalState
    extends State<RecipeIngredientUpdateModal> {
  UnitOfMeasure _dropdownValue;

  DropdownMenuItem<UnitOfMeasure> _createDropDownItem(UnitOfMeasure uom) {
    return DropdownMenuItem<UnitOfMeasure>(
      child: Text(uom.name),
      value: uom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget._recipeIngredient.name),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      children: <Widget>[
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinnerInput(
                spinnerValue: widget._recipeIngredient.quantity,
                maxValue: 9999,
                minValue: 0,
                step: 1,
                onChange: (newValue) {
                  setState(() {
                    widget._recipeIngredient.quantity = newValue;
                  });
                },
              ),
              SizedBox(
                width: 10,
              ),
              DropdownButton<UnitOfMeasure>(
                value: widget._recipeIngredient.unitOfMeasure,
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
        ),
      ],
    );
  }
}
