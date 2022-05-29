import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../models/enums/meal.dart';
import '../../models/menu.dart';
import '../../models/recipe.dart';
import '../recipe_view/screen.dart';
import 'screen.dart';

final feedbackHorizontalOffsetProvider =
    StateProvider.autoDispose<Offset>((_) => Offset.zero);

class DraggableRecipeTile extends HookConsumerWidget {
  final MealRecipe mealRecipe;

  DraggableRecipeTile(
    this.mealRecipe, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMenuRecipesMap = {...ref.watch(menuRecipeSelectionProvider)};

    final isSelected = selectedMenuRecipesMap[mealRecipe.meal]
            ?.contains(mealRecipe.recipe.id) ??
        false;

    final selectedRecipes =
        selectedMenuRecipesMap.values.fold<int>(0, (pv, e) => pv + e.length);

    final selectionMode = selectedRecipes > 0;

    //Always add the current recipe the the selected recipes in case we
    // drag directly without going to selection mode.
    //The below code needs to stay there. DO NOT MOVE IT!
    var currentMealSelectedRecipes = selectedMenuRecipesMap[mealRecipe.meal];
    if (currentMealSelectedRecipes == null) {
      selectedMenuRecipesMap[mealRecipe.meal] = [mealRecipe.recipe.id];
    } else {
      if (!currentMealSelectedRecipes.contains(mealRecipe.recipe.id)) {
        currentMealSelectedRecipes = [
          ...currentMealSelectedRecipes,
          mealRecipe.recipe.id
        ];
      }
    }

    return Draggable<Map<Meal, List<String>>>(
      hitTestBehavior: HitTestBehavior.translucent,
//      affinity: Axis.vertical,
//      axis: Axis.vertical,
      onDragUpdate: (details) {
        ref.read(feedbackHorizontalOffsetProvider.notifier).state =
            details.localPosition;
      },
      feedback: _SelectedRecipesFeedback(
          selectedRecipes: selectedRecipes == 0 ? 1 : selectedRecipes),
      data: selectedMenuRecipesMap,
      onDragStarted: () => {},
      onDragCompleted: () {},
      onDragEnd: (_) {
        ref.read(feedbackHorizontalOffsetProvider.notifier).state = Offset.zero;
      },
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

    return ListTile(
      //enabled: true,
      selected: selected,
      leading: selectionMode ? Icon(Icons.drag_handle) : null,
      title: Text(mealRecipe.recipe.name),
      onTap: () => selectionMode
          ? _handleRecipeCheckChange(ref, mealRecipe, !selected)
          : _openRecipeView(mealRecipe.recipe),
      onLongPress: () => _handleRecipeCheckChange(ref, mealRecipe, !selected),
    );
  }
}

class _SelectedRecipesFeedback extends HookConsumerWidget {
  const _SelectedRecipesFeedback({
    Key? key,
    required this.selectedRecipes,
  }) : super(key: key);

  final int selectedRecipes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final feedbackHorizontalOffset =
        ref.watch(feedbackHorizontalOffsetProvider);

    print(feedbackHorizontalOffset);

    return Padding(
      padding: EdgeInsets.only(
          left: feedbackHorizontalOffset.dx - 15,
          bottom: feedbackHorizontalOffset.dy - 15),
      child: Material(
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              color: theme.primaryColor,
              shape: BoxShape.circle),
          child: Text("$selectedRecipes"),
        ),
      ),
    );
  }
}
