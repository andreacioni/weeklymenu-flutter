import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../models/ingredient.dart';
import './recipe_ingredient_modal/recipe_ingredient_modal.dart';

import '../../models/recipe.dart';

class AddIngredientButton extends StatelessWidget {
  final log = Logger((AddIngredientButton).toString());

  final RecipeOriginator _recipe;

  AddIngredientButton(this._recipe);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openAddIngredientModal(context),
      child: DottedBorder(
        child: Center(
            child: const Text(
          "+ ADD INGREDIENT",
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
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

  void _openAddIngredientModal(BuildContext context) async {
    var newRecipeIngredient = await showDialog<RecipeIngredient>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RecipeIngredientModal(_recipe.id),
    );

    if (newRecipeIngredient != null) {
      _recipe.addRecipeIngredient(newRecipeIngredient);
    } else {
      log.info("No recipe ingredient to add");
    }
  }
}
