import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../main.data.dart';
import '../../../flutter_data_state_builder.dart';
import '../recipe_ingredient_modal/recipe_ingredient_modal.dart';
import '../../../../models/ingredient.dart';
import '../../../../models/recipe.dart';

class RecipeIngredientListTile extends HookConsumerWidget {
  final RecipeOriginator _recipe;
  final RecipeIngredient recipeIngredient;
  final bool editEnabled;

  RecipeIngredientListTile(this._recipe, this.recipeIngredient,
      {this.editEnabled = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientsRepo = ref.ingredients;

    return FlutterDataStateBuilder<Ingredient>(
      state: ingredientsRepo.watchOne(recipeIngredient.ingredientId),
      notFound: buildListTile(context, false, 'Ingredient'),
      builder: (context, model) {
        final ingredient = model;
        return buildListTile(context, editEnabled, ingredient.name);
      },
    );
  }

  void openRecipeIngredientUpdateModal(BuildContext context) async {
    RecipeIngredient? updatedRecipeIng = await showDialog<RecipeIngredient>(
      context: context,
      barrierDismissible: true,
      builder: (_) => RecipeIngredientModal(recipeIngredient),
    );

    if (updatedRecipeIng != null) {
      final recipeIngredients = [..._recipe.instance.ingredients]
        ..removeWhere((ri) => ri.ingredientId == recipeIngredient.ingredientId)
        ..add(updatedRecipeIng);

      _recipe.update(_recipe.instance.copyWith(ingredients: recipeIngredients));
    } else {
      print("No update ingredient recipe returned");
    }
  }

  Widget buildListTile(
      BuildContext context, bool editEnabled, String ingredientName) {
    return Card(
      child: ListTile(
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset("assets/icons/supermarket.png"),
        ),
        title: Text(ingredientName),
        trailing: editEnabled
            ? IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => openRecipeIngredientUpdateModal(context),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    recipeIngredient.quantity?.toStringAsFixed(0) ?? '-',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    recipeIngredient.unitOfMeasure?.toString() ?? '-',
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
