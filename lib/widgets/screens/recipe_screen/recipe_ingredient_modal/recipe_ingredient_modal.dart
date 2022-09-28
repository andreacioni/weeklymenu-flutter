import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/recipe.dart';
import '../../../../models/ingredient.dart';
import '../../../shared/quantity_and_uom_input_fields.dart';
import './ingredient_selection_text_field.dart';
import '../../../../presentation/custom_icons_icons.dart';

class RecipeIngredientModal extends StatefulHookConsumerWidget {
  final RecipeIngredient? recipeIngredient;

  RecipeIngredientModal([this.recipeIngredient]);

  @override
  _RecipeIngredientModalState createState() => _RecipeIngredientModalState();
}

class _RecipeIngredientModalState extends ConsumerState<RecipeIngredientModal> {
  Ingredient? _selectedIngredient;
  double? _quantity;
  String? _unitOfMeasure;
  bool? _isFreezed = false;
  late bool _expandMore;

  late bool _updateMode;

  @override
  void initState() {
    this._expandMore = false;

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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildIngredientSelectionTextField(),
          _buildQuantityAndUomRow(),
          //_buildExpandMoreRow(),
          const SizedBox(height: 10),
          if (_expandMore) ...[
            _buildFreezedRow(),
          ],
          const SizedBox(
            height: 10,
          ),
          _buildBottomRow(),
          const SizedBox(height: 20),
        ],
      ),

      /* actions: <Widget>[
        FlatButton(
          child: Text("CANCEL"),
          textColor: Theme.of(context).primaryColor,
          onPressed: () => Navigator.of(context).pop(),
        ),
        _buildDoneButton(context, ref),
      ], */
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: () {}, child: Text('CANCEL')),
        const SizedBox(width: 10),
        ElevatedButton(onPressed: () {}, child: Text('ADD')),
      ],
    );
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
        autofocus: true,
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
    return QuantityAndUnitOfMeasureInputFormField(
      quantity: _quantity ?? 0,
      unitOfMeasure: _unitOfMeasure,
      onQuantityChanged: (newValue) => _quantity = newValue,
      onUnitOfMeasureChanged: (newValue) => _unitOfMeasure = newValue,
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
