import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objectid/objectid.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weekly_menu_app/main.data.dart';

import 'package:weekly_menu_app/models/date.dart';
import 'package:weekly_menu_app/globals/constants.dart' as consts;
import 'package:weekly_menu_app/widgets/menu_page/daily_menu_future_wrapper.dart';
import '../../globals/errors_handlers.dart';
import '../../models/enums/meal.dart';
import '../../models/menu.dart';
import '../../models/recipe.dart';
import '../menu_page/daily_menu_section.dart';
import './scroll_view.dart';
import '../../globals/hooks.dart';

final _dateParser = DateFormat('EEEE, MMMM dd');

final menuRecipeSelectionProvider = StateNotifierProvider.autoDispose<
    MenuRecipeSelectionNotifier,
    Map<Meal, List<String>>>(((_) => MenuRecipeSelectionNotifier()));

class MenuRecipeSelectionNotifier
    extends StateNotifier<Map<Meal, List<String>>> {
  MenuRecipeSelectionNotifier() : super({});

  void setSelectedRecipe(MealRecipe mealRecipe) {
    List<String> recipesList = state[mealRecipe.meal] ?? [];
    final newState = {...state};

    recipesList.add(mealRecipe.recipe.id);
    newState[mealRecipe.meal] = recipesList;

    state = newState;
  }

  void removeSelectedRecipe(MealRecipe mealRecipe) {
    final newState = {...state};
    final List<String> recipesList = state[mealRecipe.meal] ?? [];

    recipesList.removeWhere((recId) => mealRecipe.recipe.id == recId);
    if (recipesList.isEmpty) {
      newState.remove(mealRecipe.meal);
    } else {
      newState[mealRecipe.meal] = recipesList;
    }

    state = newState;
  }

  void clearSelected() {
    state.clear();
  }

  ///Get the meal of the selected recipes, _null_ is returned if no recipes are selected.
  ///If there are selected recipe that belongs to more meals _null_ is returned.
  Meal? get selectedRecipesMeal {
    Meal? meal;
    final selectedRecipesClone = Map<Meal, List<String>>.from(state);

    if (selectedRecipesClone.isNotEmpty) {
      selectedRecipesClone.removeWhere((_, recipeIds) => recipeIds.isEmpty);

      if (selectedRecipesClone.length == 1) {
        meal = selectedRecipesClone.entries.first.key;
      }
    }

    return meal;
  }

/**
 *  Returns selected recipes ids. Duplicates are removed.
*/
  List<String> get selectedRecipes {
    final recipeIds = <String>[];

    state.forEach((meal, recipeMealIds) {
      recipeMealIds.forEach((recipeId) {
        if (!recipeIds.contains(recipeId)) {
          recipeIds.add(recipeId);
        }
      });
    });

    return recipeIds;
  }

  bool get hasSelectedRecipes => selectedRecipes.isNotEmpty;
}

class MenuEditorScreen extends HookConsumerWidget {
  final DailyMenuNotifier dailyMenuNotifier;
  MenuEditorScreen(this.dailyMenuNotifier, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyMenu = useStateNotifier(dailyMenuNotifier);
    final editingEnabled =
        ref.watch(menuRecipeSelectionProvider.notifier).hasSelectedRecipes;

    final primaryColor = dailyMenu.isPast
        ? consts.pastColor
        : (dailyMenu.isToday
            ? consts.todayColor
            : Theme.of(context).primaryColor);

    final theme = Theme.of(context).copyWith(
      primaryColor: primaryColor,
      toggleableActiveColor: primaryColor,
      appBarTheme: Theme.of(context).appBarTheme.copyWith(color: primaryColor),
      splashColor: primaryColor.withOpacity(0.4),
    );

    void _handleBackButton() {
      ref.read(menuRecipeSelectionProvider.notifier).clearSelected();

      Navigator.of(context).pop();
    }

    return Theme(
      data: theme,
      child: WillPopScope(
        onWillPop: () async {
          _handleBackButton();
          return true;
        },
        child: Scaffold(
          primary: false,
          backgroundColor: Colors.transparent,
          appBar: _MenuEditorAppBar(dailyMenuNotifier),
          body: Container(
            color: Colors.white,
            child: MenuEditorScrollView(
              dailyMenuNotifier,
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuEditorAppBar extends HookConsumerWidget
    implements PreferredSizeWidget {
  final DailyMenuNotifier dailyMenuNotifier;

  const _MenuEditorAppBar(
    this.dailyMenuNotifier, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMenuRecipesMap = ref.watch(menuRecipeSelectionProvider);
    final dailyMenu = useStateNotifier(dailyMenuNotifier);

    final primaryColor = Theme.of(context).primaryColor.withOpacity(0.7);

    final selectedRecipes =
        selectedMenuRecipesMap.values.fold<int>(0, (pv, e) => pv + e.length);

    void _handleDeleteRecipes() {
      selectedMenuRecipesMap.forEach(
        (meal, recipesId) {
          if (recipesId.isNotEmpty) {
            final menu = dailyMenuNotifier.state.getMenuByMeal(meal);

            if (menu == null) {
              return;
            }

            Menu? newMenu;

            recipesId.forEach(
              (recipeIdToBeDeleted) {
                if (menu.recipes.isNotEmpty) {
                  newMenu = menu.removeRecipeById(recipeIdToBeDeleted);
                }
              },
            );
            if (newMenu != null) {
              if (newMenu!.recipes.isEmpty) {
                dailyMenuNotifier.removeMenu(newMenu!);
              } else {
                dailyMenuNotifier.updateMenu(newMenu!);
              }
            }
          }
        },
      );
      ref.read(menuRecipeSelectionProvider.notifier).clearSelected();
    }

    return AppBar(
      primary: false,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
            topLeft: MENU_CARD_ROUNDED_RECT_BORDER,
            topRight: MENU_CARD_ROUNDED_RECT_BORDER),
      ),
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Text(dailyMenu.day.format(_dateParser)),
      actions: <Widget>[
        if (dailyMenu.isPast)
          IconButton(
            icon: Icon(Icons.archive),
            onPressed: () {},
          ),
        if (selectedRecipes > 0) ...[
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Chip(
              backgroundColor: primaryColor,
              onDeleted: _handleDeleteRecipes,
              label: Text(
                selectedRecipes.toString(),
                style: TextStyle(color: Colors.black),
              ),
              deleteIcon: Icon(Icons.delete, size: 18),
              deleteIconColor: Colors.black,
            ),
          ),
          SizedBox(width: 15)
        ]
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(50);
}
