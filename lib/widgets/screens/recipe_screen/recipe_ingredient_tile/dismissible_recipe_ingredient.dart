import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './recipe_ingredient_list_tile.dart';
import '../../../../models/recipe.dart';
import '../../../../models/ingredient.dart';

class DismissibleRecipeIngredientTile extends StatelessWidget {
  final RecipeIngredient recipeIngredient;
  final bool editEnabled;
  final void Function()? onDismissed;

  DismissibleRecipeIngredientTile(
      {required this.recipeIngredient,
      this.editEnabled = false,
      this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return editEnabled
        ? Dismissible(
            key: Key(recipeIngredient.ingredientId),
            direction: DismissDirection.endToStart,
            child: RecipeIngredientListTile(
              recipeIngredient: recipeIngredient,
              editEnabled: editEnabled,
            ),
            onDismissed: (_) => onDismissed?.call())
        : RecipeIngredientListTile(
            recipeIngredient: recipeIngredient,
            editEnabled: editEnabled,
          );
  }
}
