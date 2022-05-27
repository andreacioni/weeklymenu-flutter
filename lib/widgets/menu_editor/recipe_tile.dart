import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../models/menu.dart';
import '../../models/recipe.dart';
import '../recipe_view/screen.dart';
import 'screen.dart';

class DraggableRecipeTile extends HookConsumerWidget {
  final MealRecipe mealRecipe;

  DraggableRecipeTile(
    this.mealRecipe, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMenuRecipesMap = ref.watch(menuRecipeSelectionProvider);

    final isSelected = selectedMenuRecipesMap[mealRecipe.meal]
            ?.contains(mealRecipe.recipe.id) ??
        false;

    final selectedRecipes =
        selectedMenuRecipesMap.values.fold<int>(0, (pv, e) => pv + e.length);

    final selectionMode = selectedRecipes > 0;

    return Draggable<MealRecipe>(
      feedback: Align(
        child: Material(
          color: Colors.transparent,
          child: _SelectedRecipesFeedback(selectedRecipes: selectedRecipes),
        ),
      ),
      //childWhenDragging: Container(),
      data: mealRecipe,
      onDragStarted: () => {},
      onDragCompleted: () {},
      onDragEnd: (_) {},
      onDraggableCanceled: (_, __) {},
      child: RecipeTile(
        mealRecipe,
        selected: isSelected,
        selectionMode: selectionMode,
      ),
    );
  }
}

class RecipeTile extends HookConsumerWidget {
  final MealRecipe mealRecipe;
  final bool selected;
  final bool selectionMode;

  RecipeTile(
    this.mealRecipe, {
    this.selected = false,
    this.selectionMode = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void _openRecipeView(Recipe recipe) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RecipeView(recipe),
        ),
      );
    }

    void _handleRecipeCheckChange(
        WidgetRef ref, MealRecipe mealRecipe, bool checked) {
      final menuRecipeSelection =
          ref.read(menuRecipeSelectionProvider.notifier);
      if (checked) {
        menuRecipeSelection.setSelectedRecipe(mealRecipe);
      } else {
        menuRecipeSelection.removeSelectedRecipe(mealRecipe);
      }
    }

    final theme = Theme.of(context);

    return InkWell(
      onTap: () => selectionMode
          ? _handleRecipeCheckChange(ref, mealRecipe, !selected)
          : _openRecipeView(mealRecipe.recipe),
      onLongPress: () => _handleRecipeCheckChange(ref, mealRecipe, !selected),
      child: ListTile(
        enabled: true,
        selected: selected,
        leading: selectionMode ? Icon(Icons.drag_handle) : null,
        title: Text(mealRecipe.recipe.name),
      ),
    );
  }
}

class _SelectedRecipesFeedback extends StatelessWidget {
  const _SelectedRecipesFeedback({
    Key? key,
    required this.selectedRecipes,
  }) : super(key: key);

  final int selectedRecipes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          color: theme.primaryColor,
          shape: BoxShape.circle),
      child: Text("$selectedRecipes"),
    );
  }
}
