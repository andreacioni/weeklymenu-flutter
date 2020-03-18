import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './recipe_ingredient_list_tile.dart';
import '../../../models/recipe.dart';
import '../../../models/ingredient.dart';

class DismissibleRecipeIngredientTile extends StatelessWidget {
  final bool editEnabled;

  DismissibleRecipeIngredientTile(this.editEnabled);

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
              recipeIngredient,
              editEnabled: editEnabled,
            ),
            onDismissed: (_) {
              Provider.of<Recipe>(context, listen: false)
                  .deleteRecipeIngredient(recipeIngredient.ingredientId);
            },
          )
        : RecipeIngredientListTile(
            recipeIngredient,
          );
  }
}
