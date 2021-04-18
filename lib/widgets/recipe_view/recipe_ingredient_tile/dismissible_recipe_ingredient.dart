import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './recipe_ingredient_list_tile.dart';
import '../../../models/recipe.dart';
import '../../../models/ingredient.dart';

class DismissibleRecipeIngredientTile extends StatelessWidget {
  final RecipeOriginator _recipe;
  final RecipeIngredient _recipeIngredient;
  final bool editEnabled;

  DismissibleRecipeIngredientTile(
      this._recipe, this._recipeIngredient, this.editEnabled);

  @override
  Widget build(BuildContext context) {
    return editEnabled
        ? Dismissible(
            key: Key(_recipeIngredient.ingredientId),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
            child: RecipeIngredientListTile(
              _recipe,
              _recipeIngredient,
              editEnabled: editEnabled,
            ),
            onDismissed: (_) {
              final recipeIngredients = [..._recipe.instance.ingredients]
                ..removeWhere(
                    (ri) => _recipeIngredient.ingredientId == ri.ingredientId);
              _recipe.update(
                  _recipe.instance.copyWith(ingredients: recipeIngredients));
            })
        : RecipeIngredientListTile(
            _recipe,
            _recipeIngredient,
          );
  }
}
