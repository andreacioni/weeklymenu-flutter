import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../recipe_ingredient_modal/recipe_ingredient_modal.dart';
import '../../../models/ingredient.dart';
import '../../../models/recipe.dart';
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
        title: Text(ingredient.name == null ? '' : ingredient.name),
        trailing: widget.editEnabled
            ? IconButton(
                icon: Icon(Icons.edit),
                onPressed: _openRecipeIngredientUpdateModal,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget._recipeIngredient.quantity?.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    widget._recipeIngredient.unitOfMeasure == null
                        ? '-'
                        : widget._recipeIngredient.unitOfMeasure.toString(),
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

  void _openRecipeIngredientUpdateModal() {
    showDialog<RecipeIngredient>(
      context: context,
      builder: (bContext) => RecipeIngredientModal(
        widget._recipeIngredient.recipeId,
        recipeIngredient: widget._recipeIngredient,
      ),
    ).then((updatedRecipeIng) {
      widget._recipeIngredient.quantity = updatedRecipeIng.quantity;
      widget._recipeIngredient.unitOfMeasure = updatedRecipeIng.unitOfMeasure;
      widget._recipeIngredient.freezed = updatedRecipeIng.freezed;
    });
  }
}
