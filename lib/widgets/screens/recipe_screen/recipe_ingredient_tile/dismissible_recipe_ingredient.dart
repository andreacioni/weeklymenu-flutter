import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './recipe_ingredient_list_tile.dart';
import '../../../../models/recipe.dart';
import '../../../../models/ingredient.dart';

class DismissibleRecipeIngredientTile extends StatelessWidget {
  final RecipeIngredient? recipeIngredient;
  final double? servingsMultiplierFactor;
  final bool editEnabled;
  final void Function()? onDismissed;
  final void Function(dynamic)? onRecipeIngredientCreate;
  final void Function(dynamic)? onRecipeIngredientUpdate;

  DismissibleRecipeIngredientTile(
      {this.recipeIngredient,
      this.editEnabled = false,
      this.onDismissed,
      this.onRecipeIngredientCreate,
      this.onRecipeIngredientUpdate,
      this.servingsMultiplierFactor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return editEnabled && recipeIngredient != null
        ? Dismissible(
            key: Key(recipeIngredient!.ingredientId),
            direction: DismissDirection.endToStart,
            child: RecipeIngredientListTile(
              recipeIngredient: recipeIngredient,
              editEnabled: true,
              onChanged: onRecipeIngredientUpdate,
            ),
            onDismissed: (_) => onDismissed?.call())
        : RecipeIngredientListTile(
            recipeIngredient: recipeIngredient,
            editEnabled: editEnabled,
            servingsMultiplierFactor: servingsMultiplierFactor,
            onChanged: (newRecipeIngredient) {
              if (recipeIngredient != null) {
                onRecipeIngredientUpdate?.call(newRecipeIngredient);
              } else {
                onRecipeIngredientCreate?.call(newRecipeIngredient);
              }
            },
          );
  }
}
