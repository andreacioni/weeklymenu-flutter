import 'package:flutter/material.dart';
import 'package:spinner_input/spinner_input.dart';
import 'package:provider/provider.dart';

import '../../models/ingredient.dart';
import '../../models/unit_of_measure.dart';

import '../../providers/ingredients_provider.dart';

class RecipeIngredientUpdateModal extends StatefulWidget {
  final RecipeIngredient _recipeIngredient;

  RecipeIngredientUpdateModal(this._recipeIngredient);

  @override
  _RecipeIngredientUpdateModalState createState() =>
      _RecipeIngredientUpdateModalState();
}

class _RecipeIngredientUpdateModalState
    extends State<RecipeIngredientUpdateModal> {
  String _uomDropdownValue;

  DropdownMenuItem<String> _createDropDownItem(String uom) {
    return DropdownMenuItem<String>(
      child: Text(uom),
      value: uom,
    );
  }

  @override
  Widget build(BuildContext context) {
    Ingredient ingredient =
        Provider.of<IngredientsProvider>(context, listen: false)
            .getById(widget._recipeIngredient.ingredientId);

    return SimpleDialog(
      title: Text(ingredient.name),
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
              DropdownButton<String>(
                value: widget._recipeIngredient.unitOfMeasure,
                items: UnitOfMeasures
                    .map((uom) => _createDropDownItem(uom))
                    .toList(),
                onChanged: (s) {
                  setState(() {
                    _uomDropdownValue = s;
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
