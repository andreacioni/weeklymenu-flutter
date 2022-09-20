import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../../models/recipe.dart';
import '../../../shared/editable_text_field.dart';
import '../add_ingredient_button.dart';
import '../recipe_ingredient_tile/dismissible_recipe_ingredient.dart';

class RecipeIngredientsTab extends StatelessWidget {
  final bool editEnabled;
  final RecipeOriginator originator;

  const RecipeIngredientsTab({
    Key? key,
    required this.originator,
    this.editEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipe = originator.instance;
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        if (recipe.ingredients.isEmpty && !editEnabled)
          EditableTextField(
            "",
            editEnabled: false,
            hintText: "No ingredients",
          ),
        if (recipe.ingredients.isNotEmpty)
          ...recipe.ingredients
              .map(
                (recipeIng) => DismissibleRecipeIngredientTile(
                    originator, recipeIng, editEnabled),
              )
              .toList(),
        if (editEnabled)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AddIngredientButton(originator),
          ),
      ],
    );
  }
}
