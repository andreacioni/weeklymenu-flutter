import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spinner_input/spinner_input.dart';

import '../../../models/ingredient.dart';
import '../../../models/unit_of_measure.dart';
import './ingredient_selection_text_field.dart';
import '../../../presentation/custom_icons_icons.dart';
import '../../../providers/ingredients_provider.dart';

class AddIngredientModal extends StatefulWidget {
  @override
  _AddIngredientModalState createState() => _AddIngredientModalState();
}

class _AddIngredientModalState extends State<AddIngredientModal> {
  Ingredient _selectedIngredient;
  String _uomDropdownValue;
  double _quantitySpinnerValue = 0;
  bool _isFreezed = false;

  void _createNewRecipeIngredient() {
    if (_selectedIngredient.id == null) {
      Provider.of<IngredientsProvider>(context, listen: false).addIngredient(_selectedIngredient);
    }
    RecipeIngredient recipeIngredient = RecipeIngredient(ingredientId: _selectedIngredient.id, quantity: _quantitySpinnerValue, unitOfMeasure: _uomDropdownValue, freezed: _isFreezed);
    Navigator.of(context).pop(recipeIngredient);
  }
  

  DropdownMenuItem<String> _createDropDownItem(String uom) {
    return DropdownMenuItem<String>(
      child: Text(uom),
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
              IngredientSelectionTextField(
                onIngredientSelected: (ingredient) {
                  setState(() {
                    _selectedIngredient = ingredient;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SpinnerInput(
                    spinnerValue: _quantitySpinnerValue,
                    fractionDigits: 0,
                    minValue: 0,
                    maxValue: 9999,
                    step: 1,
                    onChange: (newValue) {
                      setState(() {
                        _quantitySpinnerValue = newValue;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: _uomDropdownValue,
                    hint: Text('Unit of Measure'),
                    items: UnitsOfMeasure
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
                    child: Text(_selectedIngredient != null && _selectedIngredient.id == null ? "CREATE & ADD" : "ADD"),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: _selectedIngredient == null ? null : _createNewRecipeIngredient,
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
