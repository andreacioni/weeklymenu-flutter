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
  @override
  _RecipeIngredientModalState createState() => _RecipeIngredientModalState();
}

class _RecipeIngredientModalState extends State<RecipeIngredientModal> {
  bool _updateMode = false;
  RecipeIngredient _recipeIngredient;
  Ingredient _selectedIngredient;

  @override
  void initState() {
    try {
      _recipeIngredient = Provider.of<RecipeIngredient>(context, listen: false);
      _selectedIngredient = Provider.of()
    } catch (_) {
      _updateMode = true;
    } 
    super.initState();
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
              buildIngredientSelectionTextField(),
              buildQuantityAndUomRow(),
              buildFreezedRow(),
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
                  buildDoneButton(context),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  void _createNewRecipeIngredient() {
    if (_selectedIngredient.id == null) {
      Provider.of<IngredientsProvider>(context, listen: false)
          .addIngredient(_selectedIngredient);
    }
    RecipeIngredient recipeIngredient = RecipeIngredient(
        ingredientId: _selectedIngredient.id,
        quantity: _quantitySpinnerValue,
        unitOfMeasure: _uomDropdownValue,
        freezed: _isFreezed);
    Navigator.of(context).pop(recipeIngredient);
  }

  DropdownMenuItem<String> _createDropDownItem(String uom) {
    return DropdownMenuItem<String>(
      child: Text(uom),
      value: uom,
    );
  }

  IngredientSelectionTextField buildIngredientSelectionTextField() {
    Ingredient ingredient =
        Provider.of<IngredientsProvider>(context, listen: false)
            .getById(widget.recipeIngredient.ingredientId);
    return widget.recipeIngredient == null
        ? IngredientSelectionTextField(
            onIngredientSelected: (ingredient) {
              setState(() {
                _selectedIngredient = ingredient;
              });
            },
          )
        : Text(ingredient.name);
  }

  Widget buildFreezedRow() {
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
            value: _recipeIngredient.freezed,
            onChanged: (newValue) => _recipeIngredient.freezed == false)
      ],
    );
  }

  Widget buildQuantityAndUomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SpinnerInput(
          spinnerValue: _recipeIngredient.quantity,
          fractionDigits: 0,
          minValue: 0,
          maxValue: 9999,
          step: 1,
          onChange: (newValue) => _recipeIngredient.quantity = newValue,
        ),
        DropdownButton<String>(
          value: _recipeIngredient.unitOfMeasure,
          hint: Text('Unit of Measure'),
          items: UnitsOfMeasure.map((uom) => _createDropDownItem(uom)).toList(),
          onChanged: (newValue) => _recipeIngredient.unitOfMeasure = newValue,
        ),
      ],
    );
  }

  Widget buildDoneButton(BuildContext context) {
    if (widget.recipeIngredient == null) {
      return FlatButton(
        child: Text(
            _selectedIngredient != null && _selectedIngredient.id == null
                ? "CREATE & ADD"
                : "ADD"),
        textColor: Theme.of(context).primaryColor,
        onPressed:
            _selectedIngredient == null ? null : _createNewRecipeIngredient,
      );
    } else {
      return FlatButton(
        child: Text("UPDATE"),
        textColor: Theme.of(context).primaryColor,
        onPressed:
            _selectedIngredient == null ? null : _createNewRecipeIngredient,
      );
    }
  }
}
