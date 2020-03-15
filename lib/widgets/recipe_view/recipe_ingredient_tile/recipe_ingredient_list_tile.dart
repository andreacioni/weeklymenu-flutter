import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../recipe_ingredient_update_modal.dart';
import '../../../models/ingredient.dart';
import '../../../providers/ingredients_provider.dart';

class RecipeIngredientListTile extends StatefulWidget {
  final RecipeIngredient _recipeIngredient;
  final bool editEnabled;

  RecipeIngredientListTile(this._recipeIngredient, {this.editEnabled = false});

  @override
  _RecipeIngredientListTileState createState() =>
      _RecipeIngredientListTileState();
}

class _RecipeIngredientListTileState extends State<RecipeIngredientListTile> {
  void _openRecipeIngredientUpdateModal() {
    showDialog(
        context: context,
        builder: (bContext) =>
            RecipeIngredientUpdateModal(widget._recipeIngredient));
  }

  @override
  Widget build(BuildContext context) {
    Ingredient ingredient =
        Provider.of<IngredientsProvider>(context, listen: false)
            .getById(widget._recipeIngredient.ingredientId);
    return Card(
      child: ListTile(
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset("assets/icons/supermarket.png"),
        ),
        title: Text(ingredient.name),
        trailing: widget.editEnabled
            ? IconButton(
                icon: Icon(Icons.edit),
                onPressed: _openRecipeIngredientUpdateModal,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget._recipeIngredient.quantity.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    widget._recipeIngredient.unitOfMeasure.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
