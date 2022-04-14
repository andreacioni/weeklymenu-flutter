import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
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
import './scroll_view.dart';
import '../../globals/hooks.dart';

final _dateParser = DateFormat('EEEE, MMMM dd');

final menuRecipeSelectionProvider = StateNotifierProvider.autoDispose<
    MenuRecipeSelectionNotifier,
    Map<Meal, List<String>>>(((ref) => MenuRecipeSelectionNotifier()));

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
    newState[mealRecipe.meal] = recipesList;

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

    final primaryColor = dailyMenu.isPast
        ? consts.pastColor
        : (dailyMenu.isToday
            ? consts.todayColor
            : Theme.of(context).primaryColor);

    final theme = Theme.of(context).copyWith(
      primaryColor: primaryColor,
      toggleableActiveColor: primaryColor,
      appBarTheme: AppBarTheme(
        color: primaryColor,
      ),
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
          appBar: _MenuEditorAppBar(dailyMenuNotifier),
          body: Container(
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
    final menuRecipeSelection = ref.watch(menuRecipeSelectionProvider);
    final dailyMenu = useStateNotifier(dailyMenuNotifier);

    void _handleDeleteRecipes() {
      menuRecipeSelection.forEach(
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

    void _handleSwapRecipes({bool cut = true}) async {
      /**    //Ask for destination day
      final destinationDateTime = await showDatePicker(
        context: context,
        initialDate: dailyMenu.day.toDateTime,
        firstDate: Date.now()
            .subtract(Duration(days: (consts.pageViewLimitDays / 2).truncate()))
            .toDateTime,
        lastDate: Date.now()
            .add((Duration(days: (consts.pageViewLimitDays / 2).truncate())))
            .toDateTime,
      );

      if (destinationDateTime == null) {
        return;
      }

      final destinationDay = Date(destinationDateTime);

      //Ask for destination meal
      final destinationMeal = await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text("Select meal"),
          children: Meal.values
              .map(
                (meal) => InkWell(
                    child: ListTile(
                      title: Text(meal.toString()),
                    ),
                    onTap: () => Navigator.of(context).pop(meal)),
              )
              .toList(),
        ),
      );

      if (destinationMeal == null) {
        return;
      }

      //Check for empty/notEmpty destination menu
      //final menuRepository = context.read(menusRepositoryProvider);
      //_destinationMenu =
      //    await menuRepository.findAll(param: {'day': destinationDay}); //TODO fix me

      /* 
      Ask action to be performed if there are recipes already 
      defined in selected (day, meal), otherwise just move (and create
      menu if not defined)
    */
      if (_destinationMenu?.menus.isEmpty ?? true) {
        print("No menus in destination day, creating menu");
        _newMenu = Menu(
          id: ObjectId().hexString,
          meal: destinationMeal,
          date: destinationDay,
          recipes: menuRecipeSelectionNotifier.selectedRecipes,
        );
      } else {
        //Check if all selected recipes are in the same meal
        final sameMeal = menuRecipeSelectionNotifier.selectedRecipesMeal;
        final alreadyDefinedMenu =
            _destinationMenu!.getMenuByMeal(destinationMeal);

        if (alreadyDefinedMenu == null) {
          print("Destination menu is not already defined, creating menu");
          _newMenu = Menu(
            id: ObjectId().hexString,
            meal: destinationMeal,
            date: destinationDay,
            recipes: menuRecipeSelectionNotifier.selectedRecipes,
          );
        } else if (alreadyDefinedMenu.recipes.isEmpty) {
          print("Destination menu is defined but empty, add new recipes to it");
          alreadyDefinedMenu
              .addRecipes(menuRecipeSelectionNotifier.selectedRecipes);
        } else {
          /**
         * If sameMeal == null it means that selected recipes in current menu
         * belong to more meals and so it's impossible to ask for move/swap. Instead
         * we can ask for merge/overwrite current selected recipes in destination menu 
         * */
          if (sameMeal == null) {
            final mergeRecipes = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Overwrite or Merge?"),
                content: Text(
                    "There are alredy defined recipes for that meal. Would you merge or overwrite them?"),
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text("MERGE")),
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("OVERWRITE"))
                ],
              ),
            );

            if (!(mergeRecipes ?? false)) {
              print("Overwriting recipes");
              _destinationMenu!.removeAllRecipesFromMeal(destinationMeal);
            }
            _destinationMenu!.addRecipeIdListToMeal(
                destinationMeal, menuRecipeSelectionNotifier.selectedRecipes);
          } else {
            print(
                "Destination menu is present, do you want to swap or move recipes?");

            final swapRecipes = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Swap or Merge?"),
                content: Text(
                    "There are alredy defined recipes for that meal. Would you merge or swap them?"),
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("MERGE")),
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text("SWAP"))
                ],
              ),
            );

            if (swapRecipes ?? false) {
              print("Swapping recipes");
              final destinationRecipes =
                  _destinationMenu!.getRecipeIdsByMeal(destinationMeal);
              dailyMenu.addRecipeIdListToMeal(sameMeal, destinationRecipes);
              _destinationMenu!.removeAllRecipesFromMeal(destinationMeal);
            }
            _destinationMenu!.addRecipeIdListToMeal(
                destinationMeal, menuRecipeSelectionNotifier.selectedRecipes);
          }
        }
      }
      if (cut) {
        dailyMenu
            .removeRecipesFromMeal(menuRecipeSelectionNotifier.selectedRecipes);
      }

      menuRecipeSelectionNotifier.clearSelected();
      */
    }

    void _handleBackButton() {
      ref.read(menuRecipeSelectionProvider.notifier).clearSelected();

      Navigator.of(context).pop();
    }

    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => _handleBackButton(),
      ),
      title: Text(dailyMenu.day.format(_dateParser)),
      actions: <Widget>[
        if (dailyMenu.isPast)
          IconButton(
            icon: Icon(Icons.archive),
            onPressed: () {},
          ),
        IconButton(
          icon: Icon(Icons.swap_horiz),
          onPressed:
              ref.read(menuRecipeSelectionProvider.notifier).hasSelectedRecipes
                  ? () => _handleSwapRecipes()
                  : null,
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed:
              ref.read(menuRecipeSelectionProvider.notifier).hasSelectedRecipes
                  ? () => _handleDeleteRecipes()
                  : null,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(50);
}
