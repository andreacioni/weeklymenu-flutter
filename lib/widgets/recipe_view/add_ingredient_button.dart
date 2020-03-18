import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';

import '../../models/ingredient.dart';
import './recipe_ingredient_modal/recipe_ingredient_modal.dart';

import '../../models/recipe.dart';
import '../../providers/recipes_provider.dart';

class AddIngredientButton extends StatelessWidget {
  final Recipe recipe;

  const AddIngredientButton(this.recipe);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog<RecipeIngredient>(
              context: context,
              builder: (_) => RecipeIngredientModal(recipe.id))
          .then((recipeIng) {
        if (recipeIng != null) {
          recipe.addRecipeIngredient(recipeIng);
        }
      }),
      child: DottedBorder(
        child: Center(
            child: const Text(
          "+ ADD INGREDIENT",
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey),
        )),
        strokeWidth: 5,
        dashPattern: [4, 10],
        color: Colors.grey,
        padding: EdgeInsets.all(10),
        borderType: BorderType.RRect,
        radius: Radius.circular(9),
        strokeCap: StrokeCap.round,
      ),
    );
  }
}