import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../number_text_field.dart';
import '../../../models/recipe.dart';
import '../../../models/ingredient.dart';
import '../../../models/enums/unit_of_measure.dart';
import './ingredient_selection_text_field.dart';
import '../../../presentation/custom_icons_icons.dart';

class RecipeIngredientModal extends StatefulWidget {
  final RecipeIngredient? recipeIngredient;

  RecipeIngredientModal([this.recipeIngredient]);

  @override
  _RecipeIngredientModalState createState() => _RecipeIngredientModalState();
}

class _RecipeIngredientModalState extends State<RecipeIngredientModal> {
  Ingredient? _selectedIngredient;
  double? _quantity;
  String? _unitOfMeasure;
  bool? _isFreezed = false;
  late bool _expandMore;

  late bool _updateMode;

  @override
  void initState() {
    _expandMore = false;

    if (widget.recipeIngredient == null) {
      _updateMode = false;
    } else {
      _updateMode = true;
      _quantity = widget.recipeIngredient?.quantity;
      _isFreezed = widget.recipeIngredient?.freezed;
      _unitOfMeasure = widget.recipeIngredient?.unitOfMeasure;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HookConsumer(builder: (context, ref, _) {
      return AlertDialog(
        content: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: [
                  _buildIngredientSelectionTextField(),
                  IconButton(
                      icon: Icon(
                          _expandMore ? Icons.expand_less : Icons.expand_more),
                      onPressed: () =>
                          setState(() => _expandMore = !_expandMore)),
                ],
              ),
              if (_expandMore) ...[
                _buildQuantityAndUomRow(),
                SizedBox(
                  height: 10,
                ),
                _buildFreezedRow(),
              ],
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("CANCEL"),
            textColor: Theme.of(context).primaryColor,
            onPressed: () => Navigator.of(context).pop(),
          ),
          _buildDoneButton(context, ref),
        ],
      );
    });
  }

  void _handleAddButton(WidgetRef ref) async {
    var ingredientToAddId = _selectedIngredient!.id;

    Navigator.of(context).pop(
      RecipeIngredient(
        ingredientId: ingredientToAddId,
        freezed: _isFreezed,
        quantity: _quantity,
        unitOfMeasure: _unitOfMeasure,
      ),
    );
  }

  void _updateRecipeIngredient() {
    Navigator.of(context).pop(
      RecipeIngredient(
        ingredientId: _selectedIngredient!.id,
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
    return Flexible(
      child: IngredientSelectionTextField(
        value: _selectedIngredient,
        enabled: _selectedIngredient == null,
        onIngredientSelected: (ingredient) =>
            setState(() => _selectedIngredient = ingredient),
      ),
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
          value: _isFreezed ?? false,
          onChanged: (newValue) => setState(() => _isFreezed = newValue),
        ),
      ],
    );
  }

  Widget _buildQuantityAndUomRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Flexible(
          child: NumberFormField(
            initialValue: _quantity?.toDouble() ?? 0,
            minValue: 0,
            maxValue: 9999,
            onChanged: (newValue) => setState(() => _quantity = newValue),
            labelText: "Quantity",
            hintText: 'Quantity',
            onSaved: (_) {},
          ),
        ),
        SizedBox(
          width: 10,
        ),
        DropdownButton<String>(
          value: _unitOfMeasure,
          hint: Text('Unit of Measure'),
          underline: null,
          isDense: true,
          items: UnitsOfMeasure.map((uom) => _createDropDownItem(uom)).toList(),
          onChanged: (newValue) => setState(
            () => _unitOfMeasure = newValue,
          ),
        ),
      ],
    );
  }

  Widget _buildDoneButton(BuildContext context, WidgetRef ref) {
    if (_updateMode == false) {
      return FlatButton(
        child: Text("ADD"),
        textColor: Theme.of(context).primaryColor,
        onPressed:
            _selectedIngredient == null ? null : () => _handleAddButton(ref),
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
