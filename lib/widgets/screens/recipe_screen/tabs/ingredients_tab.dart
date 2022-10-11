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

    final servings = ref.watch(recipeScreenNotifierProvider
            .select((n) => n.recipeOriginator.instance.servs)) ??
        1;
    final servingsMultiplier =
        ref.read(recipeScreenNotifierProvider).servingsMultiplier ?? servings;
    final servingsMultiplierFactor = ref.watch(
        recipeScreenNotifierProvider.select((n) => n.servingsMultiplierFactor));

    Widget buildNewIngredientTile() {
      return Card(
        child: ListTile(
          title: IngredientSuggestionTextField(
            autofocus: true,
            onSubmitted: (value) {
              notifier.newIngredientMode = false;

              if (value is Ingredient) {
                notifier.addRecipeIngredientFromIngredient(value);
              } else if (value is String) {
                notifier.addRecipeIngredientFromString(value);
              }
            },
            onFocusChanged: (focus) {
              if (!focus) {
                notifier.newIngredientMode = false;
              }
            },
          ),
        ),
      );
    }

    List<Widget> buildDismissibleRecipeTiles() {
      return recipeIngredients.mapIndexed((recipeIng, idx) {
        return DismissibleRecipeIngredientTile(
          servingsMultiplierFactor: servingsMultiplierFactor,
          recipeIngredient: recipeIng,
          editEnabled: editEnabled,
          updateRecipeIngredient: (newRecipeIngredient) {
            notifier.updateRecipeIngredientAtIndex(idx, newRecipeIngredient);
          },
          onDismissed: () {
            notifier.deleteRecipeIngredientByIndex(idx);
          },
        );
      }).toList();
    }

    Widget buildServingMultiplayer() {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                splashRadius: 13,
                onPressed: servingsMultiplier > 1
                    ? () => notifier.servingsMultiplier = servingsMultiplier - 1
                    : null,
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Colors.amber.shade400,
                )),
            Text(
              servingsMultiplier.toString(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(width: 5),
            Text(
              'servings',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            IconButton(
                splashRadius: 13,
                onPressed: () =>
                    notifier.servingsMultiplier = servingsMultiplier + 1,
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.amber.shade400,
                ))
          ],
        ),
      );
    }

    return Column(
      children: [
        if (!newIngredientMode && recipeIngredients.isEmpty)
          EmptyPagePlaceholder(
            icon: Icons.add_circle_outline_sharp,
            text: 'No ingredients yet',
            sizeRate: 0.8,
            margin: EdgeInsets.only(top: 100),
          ),
        if (!editEnabled && recipeIngredients.isNotEmpty)
          buildServingMultiplayer(),
        if (newIngredientMode) buildNewIngredientTile(),
        if (recipeIngredients.isNotEmpty) ...buildDismissibleRecipeTiles(),
      ],
    );
  }
}
