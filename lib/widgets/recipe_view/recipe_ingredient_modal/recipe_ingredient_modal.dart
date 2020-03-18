import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spinner_input/spinner_input.dart';

import '../../../models/recipe.dart';
import '../../../models/ingredient.dart';
import '../../../models/unit_of_measure.dart';
import './ingredient_selection_text_field.dart';
import '../../../presentation/custom_icons_icons.dart';
import '../../../providers/ingredients_provider.dart';

class RecipeIngredientModal extends StatefulWidget {
  final String recipeId;
  final RecipeIngredient recipeIngredient;

  RecipeIngredientModal(this.recipeId, {this.recipeIngredient});

  @override
  _RecipeIngredientModalState createState() => _RecipeIngredientModalState();
}

class _RecipeIngredientModalState extends State<RecipeIngredientModal> {
  bool _updateMode = false;
  Ingredient _selectedIngredient;

  @override
  Widget build(BuildContext context) {
    RecipeIngredient recipeIngredient = _getOrSetRecipeIngredient();
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              _buildIngredientSelectionTextField(recipeIngredient),
              _buildQuantityAndUomRow(recipeIngredient),
              _buildFreezedRow(recipeIngredient),
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
                  _buildDoneButton(context, recipeIngredient),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  RecipeIngredient _getOrSetRecipeIngredient() {
    RecipeIngredient recipeIngredient = widget.recipeIngredient;

    if (recipeIngredient == null) {
      recipeIngredient = RecipeIngredient(
        parentRecipeId: null,
        ingredientId: widget.recipeId,
        freezed: false,
        quantity: 0,
        unitOfMeasure: null,
      );
    }

    return recipeIngredient;
  }

  void _createNewRecipeIngredient(RecipeIngredient recipeIngredient) {
    if (_selectedIngredient.id == null) {
      Provider.of<IngredientsProvider>(context, listen: false)
          .addIngredient(_selectedIngredient);
    }
    Navigator.of(context).pop(recipeIngredient);
  }

  DropdownMenuItem<String> _createDropDownItem(String uom) {
    return DropdownMenuItem<String>(
      child: Text(uom),
      value: uom,
    );
  }

  IngredientSelectionTextField _buildIngredientSelectionTextField(RecipeIngredient recipeIngredient ) {
    Ingredient ingredient =
        Provider.of<IngredientsProvider>(context, listen: false)
            .getById(recipeIngredient.ingredientId);
    return recipeIngredient == null
        ? IngredientSelectionTextField(
            onIngredientSelected: (ingredient) {
              setState(() {
                _selectedIngredient = ingredient;
              });
            },
          )
        : Text(ingredient.name);
  }

  Widget _buildFreezedRow(RecipeIngredient recipeIngredient) {
    return Row(
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
            value: recipeIngredient.freezed,
            onChanged: (newValue) => recipeIngredient.freezed == false)
      ],
    );
  }

  Widget _buildQuantityAndUomRow(RecipeIngredient recipeIngredient ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SpinnerInput(
          spinnerValue: recipeIngredient.quantity,
          fractionDigits: 0,
          minValue: 0,
          maxValue: 9999,
          step: 1,
          onChange: (newValue) => recipeIngredient.quantity = newValue,
        ),
        DropdownButton<String>(
          value: recipeIngredient.unitOfMeasure,
          hint: Text('Unit of Measure'),
          items: UnitsOfMeasure.map((uom) => _createDropDownItem(uom)).toList(),
          onChanged: (newValue) => recipeIngredient.unitOfMeasure = newValue,
        ),
      ],
    );
  }

  Widget _buildDoneButton(BuildContext context, RecipeIngredient recipeIngredient) {
    if (_updateMode == false) {
      return FlatButton(
        child: Text(
            _selectedIngredient != null && _selectedIngredient.id == null
                ? "CREATE & ADD"
                : "ADD"),
        textColor: Theme.of(context).primaryColor,
        onPressed:
            _selectedIngredient == null ? null : () => _createNewRecipeIngredient(recipeIngredient),
      );
    } else {
      return FlatButton(
        child: Text("DONE"),
        textColor: Theme.of(context).primaryColor,
        onPressed: null,
      );
    }
  }
}
