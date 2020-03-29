import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spinner_input/spinner_input.dart';

import '../../../models/recipe.dart';
import '../../../models/ingredient.dart';
import '../../../models/enums/unit_of_measure.dart';
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
  Ingredient _selectedIngredient;
  double _quantity = 0;
  String _unitOfMeasure;
  bool _isFreezed = false;

  bool _updateMode;

  @override
  void initState() {
    if (widget.recipeIngredient == null) {
      _updateMode = false;
    } else {
      _updateMode = true;

      Ingredient ingredient =
          Provider.of<IngredientsProvider>(context, listen: false)
              .getById(widget.recipeIngredient.ingredientId);

      _selectedIngredient = ingredient;
      _quantity = widget.recipeIngredient.quantity;
      _isFreezed = widget.recipeIngredient.freezed;
      _unitOfMeasure = widget.recipeIngredient.unitOfMeasure;
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
              _buildIngredientSelectionTextField(),
              _buildQuantityAndUomRow(),
              _buildFreezedRow(),
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
                  _buildDoneButton(context),
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
          .addIngredient(_selectedIngredient)
          .then(
            (createdIngredient) => Navigator.of(context).pop(
              RecipeIngredient(
                recipeId: widget.recipeId,
                ingredientId: createdIngredient.id,
                freezed: _isFreezed,
                quantity: _quantity,
                unitOfMeasure: _unitOfMeasure,
              ),
            ),
          );
    }
  }

  void _updateRecipeIngredient() {
    Navigator.of(context).pop(
      RecipeIngredient(
        recipeId: widget.recipeIngredient.recipeId,
        ingredientId: _selectedIngredient.id,
        freezed: _isFreezed,
        quantity: _quantity,
        unitOfMeasure: _unitOfMeasure,
      ),
    );
  }

  DropdownMenuItem<String> _createDropDownItem(String uom) {
    return DropdownMenuItem<String>(
      child: Text(uom),
      value: uom,
    );
  }

  Widget _buildIngredientSelectionTextField() {
    return IngredientSelectionTextField(
      value: _selectedIngredient,
      enabled: _selectedIngredient == null,
      onIngredientSelected: (ingredient) =>
          setState(() => _selectedIngredient = ingredient),
    );
  }

  Widget _buildFreezedRow() {
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
          value: _isFreezed,
          onChanged: (newValue) => setState(() => _isFreezed = newValue),
        ),
      ],
    );
  }

  Widget _buildQuantityAndUomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SpinnerInput(
          spinnerValue: _quantity,
          fractionDigits: 0,
          minValue: 0,
          maxValue: 9999,
          step: 1,
          onChange: (newValue) => setState(() => _quantity = newValue),
        ),
        DropdownButton<String>(
          value: _unitOfMeasure,
          hint: Text('Unit of Measure'),
          items: UnitsOfMeasure.map((uom) => _createDropDownItem(uom)).toList(),
          onChanged: (newValue) => setState(
            () => _unitOfMeasure = newValue,
          ),
        ),
      ],
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    if (_updateMode == false) {
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
        child: Text("DONE"),
        textColor: Theme.of(context).primaryColor,
        onPressed: _updateRecipeIngredient,
      );
    }
  }
}
