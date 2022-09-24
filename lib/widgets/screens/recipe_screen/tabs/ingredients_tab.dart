import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/models/ingredient.dart';
import 'package:weekly_menu_app/widgets/screens/recipe_screen/recipe_ingredient_tile/ingredient_suggestion_text_field.dart';
import 'package:weekly_menu_app/widgets/shared/empty_page_placeholder.dart';

import '../../../../models/recipe.dart';
import '../../../shared/editable_text_field.dart';
import '../notifier.dart';
import '../recipe_ingredient_tile/dismissible_recipe_ingredient.dart';
import '../recipe_ingredient_tile/recipe_ingredient_list_tile.dart';
import '../../../../main.data.dart';

class RecipeIngredientsTab extends HookConsumerWidget {
  final bool editEnabled;
  final RecipeOriginator originator;

  const RecipeIngredientsTab({
    Key? key,
    required this.originator,
    this.editEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newIngredientMode = ref
        .watch(recipeScreenNotifierProvider.select((n) => n.newIngredientMode));
    final recipe = originator.instance;
    final notifier = ref.read(recipeScreenNotifierProvider.notifier);

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
      return recipe.ingredients
          .map(
            (recipeIng) => DismissibleRecipeIngredientTile(
                originator, recipeIng, editEnabled),
          )
          .toList();
    }

    return Column(
      children: [
        if (!newIngredientMode && recipe.ingredients.isEmpty)
          EmptyPagePlaceholder(
            icon: Icons.add_circle_outline_sharp,
            text: 'No ingredients yet',
            sizeRate: 0.8,
            margin: EdgeInsets.only(top: 100),
          ),
        if (newIngredientMode) buildNewIngredientTile(),
        if (recipe.ingredients.isNotEmpty) ...buildDismissibleRecipeTiles(),
      ],
    );
  }
}
