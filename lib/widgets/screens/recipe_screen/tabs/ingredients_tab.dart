import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../globals/utils.dart';
import '../../../../models/ingredient.dart';
import '../recipe_ingredient_tile/ingredient_suggestion_text_field.dart';
import '../../../shared/empty_page_placeholder.dart';
import '../../../../models/recipe.dart';
import '../../../../providers/screen_notifier.dart';
import '../../../shared/editable_text_field.dart';
import '../recipe_screen_state_notifier.dart';
import '../recipe_ingredient_tile/dismissible_recipe_ingredient.dart';
import '../recipe_ingredient_tile/recipe_ingredient_list_tile.dart';
import '../../../../main.data.dart';

class RecipeIngredientsTab extends HookConsumerWidget {
  const RecipeIngredientsTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(recipeScreenNotifierProvider.notifier);

    final editEnabled =
        ref.watch(recipeScreenNotifierProvider.select((n) => n.editEnabled));
    final newIngredientMode = ref
        .watch(recipeScreenNotifierProvider.select((n) => n.newIngredientMode));
    final recipeIngredients = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.ingredients));

    final servingsMultiplierFactor = ref.watch(
        recipeScreenNotifierProvider.select((n) => n.servingsMultiplierFactor));

    Widget buildNewIngredientTile() {
      return DismissibleRecipeIngredientTile(
        key: ValueKey('new'),
        servingsMultiplierFactor: servingsMultiplierFactor,
        editEnabled: editEnabled,
        onRecipeIngredientCreate: (value) {
          notifier.newIngredientMode = false;
          if (value is Ingredient) {
            notifier.addRecipeIngredientFromIngredient(value);
          } else if (value is String) {
            notifier.addRecipeIngredientFromString(value);
          } else if (value is RecipeIngredient) {}
        },
        onFocusChanged: (hasFocus) {
          if (!hasFocus) {
            notifier.newIngredientMode = false;
          }
        },
        onDismissed: () {
          notifier.newIngredientMode = false;
        },
      );
    }

    List<Widget> buildDismissibleRecipeTiles() {
      return recipeIngredients.mapIndexed((recipeIng, idx) {
        return DismissibleRecipeIngredientTile(
          key: ValueKey(recipeIng),
          servingsMultiplierFactor: servingsMultiplierFactor,
          recipeIngredient: recipeIng,
          editEnabled: editEnabled,
          onRecipeIngredientUpdate: (value) {
            notifier.newIngredientMode = false;

            if (value is RecipeIngredient) {
              notifier.updateRecipeIngredientAtIndex(idx, value);
            } else if (value is Ingredient) {
              notifier.updateRecipeIngredientFromIngredientAtIndex(idx, value);
            } else if (value is String) {
              notifier.updateRecipeIngredientFromStringAtIndex(idx, value);
            }
          },
          onFocusChanged: (hasFocus) {
            if (!hasFocus) {
              notifier.newIngredientMode = false;
            }
          },
          onDismissed: () {
            notifier.newIngredientMode = false;

            notifier.deleteRecipeIngredientByIndex(idx);
          },
        );
      }).toList();
    }

    return Column(
      children: [
        if (!newIngredientMode && recipeIngredients.isEmpty)
          EmptyPagePlaceholder(
            icon: Icons.add_circle_outline_sharp,
            text: 'No ingredients yet',
            sizeRate: 0.8,
            margin: const EdgeInsets.only(top: 100),
          ),
        if (newIngredientMode) buildNewIngredientTile(),
        if (recipeIngredients.isNotEmpty) ...buildDismissibleRecipeTiles(),
      ],
    );
  }
}
