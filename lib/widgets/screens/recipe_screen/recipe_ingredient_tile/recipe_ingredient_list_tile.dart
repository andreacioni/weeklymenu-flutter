import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekly_menu_app/widgets/screens/recipe_screen/recipe_ingredient_tile/ingredient_suggestion_text_field.dart';

import '../../../../main.data.dart';
import '../../../shared/flutter_data_state_builder.dart';
import '../recipe_ingredient_modal/recipe_ingredient_modal.dart';
import '../../../../models/ingredient.dart';
import '../../../../models/recipe.dart';

class RecipeIngredientListTile extends HookConsumerWidget {
  final RecipeIngredient? recipeIngredient;
  final bool editEnabled;
  final bool autofocus;

  RecipeIngredientListTile({
    this.recipeIngredient,
    this.editEnabled = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientsRepo = ref.ingredients;

    if (recipeIngredient != null) {
      return FlutterDataStateBuilder<Ingredient>(
        state: ingredientsRepo.watchOne(recipeIngredient!.ingredientId),
        notFound: _RecipeIngredientListTile(),
        builder: (context, model) {
          final ingredient = model;

          return _RecipeIngredientListTile(
            ingredient: ingredient,
            recipeIngredient: recipeIngredient,
            editEnabled: editEnabled,
          );
        },
      );
    } else {
      return _RecipeIngredientListTile();
    }
  }
}

class _RecipeIngredientListTile extends StatelessWidget {
  final RecipeIngredient? recipeIngredient;
  final Ingredient? ingredient;
  final bool editEnabled;

  const _RecipeIngredientListTile(
      {Key? key,
      this.recipeIngredient,
      this.ingredient,
      this.editEnabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: IngredientSuggestionTextField(
          ingredient: ingredient,
        ),
        trailing: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                recipeIngredient?.quantity?.toStringAsFixed(0) ?? '-',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                recipeIngredient?.unitOfMeasure ?? '-',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
