import 'package:flutter/material.dart';

import 'package:spinner_input/spinner_input.dart';

import '../../models/ingredient.dart';

class RecipeIngredientUpdateModal extends StatefulWidget {
  final RecipeIngredient _recipeIngredient;

  RecipeIngredientUpdateModal(this._recipeIngredient);

  @override
  _RecipeIngredientUpdateModalState createState() =>
      _RecipeIngredientUpdateModalState();
}

class _RecipeIngredientUpdateModalState
    extends State<RecipeIngredientUpdateModal> {
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
              DropdownButton<String>(
                value: "Easy",
                //icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black, fontSize: 18),
                onChanged: (String newValue) {
                  //setState(() {
                  //dropdownValue = newValue;
                  //});
                },
                items: <String>['Easy', 'Two', 'Free', 'Four']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
