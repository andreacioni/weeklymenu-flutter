import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './recipe_ingredient_list_tile.dart';
import '../../../models/recipe.dart';
import '../../../models/ingredient.dart';

class DismissibleRecipeIngredientTile extends StatelessWidget {
  final RecipeOriginator _recipe;
  final bool editEnabled;

  DismissibleRecipeIngredientTile(this._recipe, this.editEnabled);

  @override
  Widget build(BuildContext context) {
    RecipeIngredient recipeIngredient = Provider.of<RecipeIngredient>(context);
    return editEnabled
        ? Dismissible(
            key: Key(recipeIngredient.ingredientId),
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
              recipeIngredient,
              editEnabled: editEnabled,
            ),
            onDismissed: (_) =>
                _recipe.deleteRecipeIngredient(recipeIngredient.ingredientId),
          )
        : RecipeIngredientListTile(
            _recipe,
            recipeIngredient,
          );
  }
}
