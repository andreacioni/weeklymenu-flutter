import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:objectid/objectid.dart';
import 'package:weekly_menu_app/globals/hooks.dart';

import '../../homepage.dart';
import '../../main.data.dart';
import '../flutter_data_state_builder.dart';
import '../../models/enums/meal.dart';
import '../../models/recipe.dart';
import '../../globals/constants.dart' as constants;
import '../../models/menu.dart';
import '../menu_editor/screen.dart';
import '../recipe_view/screen.dart';
import 'add_recipe_dialog.dart';

const MENU_CARD_ROUNDED_RECT_BORDER = const Radius.circular(10);

//TODO dynamic Meal label (don't want to write new code for every new Meal)
class MenuCard extends HookConsumerWidget {
  static final _dialogDateParser = DateFormat('EEEE, dd');
  static final _appBarDateParser = DateFormat('EEE,dd');
  static final _appBarMonthParser = DateFormat('MMM');

  final DailyMenuNotifier dailyMenuNotifier;
  final void Function()? onTap;

  MenuCard(this.dailyMenuNotifier, {this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final divider = Divider(
      color: Colors.grey.shade500,
      height: 0,
    );

    final padding = const EdgeInsets.fromLTRB(10, 5, 0, 0);

    final primaryColor = dailyMenuNotifier.dailyMenu.isPast
        ? constants.pastColor
        : (dailyMenuNotifier.dailyMenu.isToday
            ? constants.todayColor
            : Colors.amber.shade200);

    Widget buildMealRecipeMenuSection(Menu? menu) {
      //TODO recipe rows could be moved to a new separated widget
      //and use a provided Menu to improve performance
      //(changes to a menu/meal won't the entire card)
      return MenuContainer(
        menu,
        dailyMenuNotifier: dailyMenuNotifier,
        padding: padding,
      );
    }

    Future<void> addRecipeToMeal(Meal meal, Recipe recipe) async {
      if (dailyMenuNotifier.dailyMenu.getMenuByMeal(meal) == null) {
        final menu = await ref.menus.save(Menu(
          date: dailyMenuNotifier.dailyMenu.day,
          recipes: [recipe.id],
          meal: meal,
        ));
        await dailyMenuNotifier.addMenu(menu);
      } else {
        await dailyMenuNotifier.addRecipeToMeal(meal, recipe);
      }
    }

    Future<void> createNewRecipeByName(Meal meal, String recipeName) async {
      if (recipeName.trim().isNotEmpty) {
        Recipe recipe = await ref.recipes
            .save(Recipe(id: ObjectId().hexString, name: recipeName));
        await addRecipeToMeal(meal, recipe);
      } else {
        print("can't create a recipe with empty name");
      }
    }

    Future<void> openAddRecipeToDailyMenuDialog() async {
      final newMealRecipe = await showDialog(
          context: context,
          builder: (context) => RecipeSelectionDialog(
              title: _dialogDateParser
                  .format(dailyMenuNotifier.dailyMenu.day.toDateTime)));

      print('selected $newMealRecipe');

      if (newMealRecipe != null && newMealRecipe['meal'] != null) {
        if (newMealRecipe['recipeTitle'] != null) {
          createNewRecipeByName(newMealRecipe['meal'] as Meal,
              newMealRecipe['recipeTitle'] as String);
        } else if (newMealRecipe['recipe'] != null) {
          addRecipeToMeal(
              newMealRecipe['meal'] as Meal, newMealRecipe['recipe'] as Recipe);
        }
      }
    }

    return Theme(
      data: Theme.of(context).copyWith(primaryColor: primaryColor),
      child: Column(
        children: [
          Container(
            //color: primaryColor.withOpacity(0.4),
            child: Padding(
              padding: padding,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    softWrap: false,
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: dailyMenuNotifier.dailyMenu.day
                              .format(_appBarDateParser) +
                          ' ',
                      style: GoogleFonts.b612Mono().copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontFeatures: [
                          FontFeature.tabularFigures(),
                        ],
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: dailyMenuNotifier.dailyMenu.day
                              .format(_appBarMonthParser),
                          style: GoogleFonts.b612Mono().copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w200,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: primaryColor.withOpacity(0.8)),
                    ),
                  ),
                  SizedBox(width: 5),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.black87,
                    ),
                    onPressed: openAddRecipeToDailyMenuDialog,
                    splashRadius: 15.0,
                  ),
                ],
              ),
            ),
          ),
          ...Meal.values
              .map((m) => buildMealRecipeMenuSection(
                  dailyMenuNotifier.dailyMenu.getMenuByMeal(m)))
              .toList()
        ],
      ),
    );
  }
}

class MealRecipeCardContainer extends StatelessWidget {
  final Meal meal;
  final String recipeId;
  final bool displayLeadingMealIcon;

  const MealRecipeCardContainer(this.meal, this.recipeId,
      {Key? key, this.displayLeadingMealIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          meal.icon,
          color: displayLeadingMealIcon ? Colors.black : Colors.transparent,
        ),
        SizedBox(width: 15),
        Expanded(
            child: MenuRecipeWrapper(
          recipeId,
          meal: meal,
        ))
      ],
    );
  }
}

class MenuContainer extends HookConsumerWidget {
  final Menu? menu;
  final DailyMenuNotifier dailyMenuNotifier;
  final EdgeInsets padding;

  MenuContainer(this.menu,
      {required this.dailyMenuNotifier, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyMenu = useStateNotifier(dailyMenuNotifier);

    if (menu == null) return Container();

    final meal = menu!.meal;

    return Padding(
      padding: padding,
      child: DragTarget<MealRecipe>(onWillAccept: (_) {
        print('on will accept');
        return true;
      }, onAccept: (mealRecipe) async {
        print('onAccept - $meal');
        ref.read(menuRecipeSelectionProvider.notifier).clearSelected();

        final recipeIds = [mealRecipe.recipe.id];

        final destinationMenu = dailyMenu.getMenuByMeal(meal);
        if (destinationMenu == null) {
          await dailyMenuNotifier.addMenu(Menu(
                  id: ObjectId().hexString,
                  date: dailyMenu.day,
                  meal: meal,
                  recipes: recipeIds)
              .init(ref.read));
        } else {
          await dailyMenuNotifier.updateMenu(destinationMenu.copyWith(recipes: [
            ...destinationMenu.recipes,
            ...recipeIds
          ]).was(destinationMenu));
        }

        originDailyMenuNotifier?.removeRecipesFromMeal(meal, recipes);
      }, builder: (context, _, __) {
        final recipeIds = menu!.recipes;
        if (recipeIds.isEmpty) return Container();
        return Column(
          children: [
            ...recipeIds
                .map((id) => MealRecipeCardContainer(
                      meal,
                      id,
                      displayLeadingMealIcon: id == recipeIds[0],
                    ))
                .toList(),
            SizedBox(height: 20)
          ],
        );
      }),
    );
  }
}

class MenuRecipeWrapper extends HookConsumerWidget {
  final String recipeId;
  final Meal meal;

  MenuRecipeWrapper(this.recipeId, {required this.meal, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterDataStateBuilder<Recipe>(
        state: ref.recipes.watchOne(recipeId),
        builder: (context, recipe) {
          return MenuRecipeCard(recipe, meal: meal);
        });
  }
}

class MenuRecipeCard extends ConsumerWidget {
  final Meal meal;
  final Recipe recipe;

  MenuRecipeCard(this.recipe, {Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final borderRadius = BorderRadius.circular(10);

    void openRecipeView(Recipe recipe) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RecipeView(recipe),
        ),
      );
    }

    Widget buildDraggableFeedback(MediaQueryData mediaQuery) {
      return Container(
          decoration: BoxDecoration(borderRadius: borderRadius),
          child: MenuRecipeCard(recipe, meal: meal),
          width: mediaQuery.size.width);
    }

    Widget buildInfoAndDragSection(ThemeData theme, MediaQueryData mediaQuery) {
      return Flexible(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Draggable<MealRecipe>(
                data: MealRecipe(meal, recipe),
                dragAnchorStrategy: (_, __, ___) {
                  //print(position);
                  //TODO improve
                  return Offset(mediaQuery.size.width - 23, 0);
                },
                feedback: buildDraggableFeedback(mediaQuery),
                axis: Axis.vertical,
                affinity: Axis.vertical,
                child: Icon(
                  Icons.drag_indicator,
                  color: Colors.black38,
                  size: theme.iconTheme.size! - 1,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildImageAndTitle(
        Recipe recipe, BorderRadius borderRadius, ThemeData theme) {
      return Flexible(
        flex: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (recipe.imgUrl != null)
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: borderRadius.copyWith(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5))),
                child: Image(
                    height: 50,
                    width: 90,
                    image: CachedNetworkImageProvider(recipe.imgUrl!),
                    errorBuilder: (_, __, ___) => Container(),
                    fit: BoxFit.cover),
              ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: AutoSizeText(
                  recipe.name,
                  maxLines: 1,
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      elevation: 3,
      child: InkWell(
        borderRadius: borderRadius,
        highlightColor: theme.primaryColor.withOpacity(0.4),
        splashColor: theme.primaryColor.withOpacity(0.6),
        onTap: () => openRecipeView(recipe),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildImageAndTitle(recipe, borderRadius, theme),
            buildInfoAndDragSection(theme, mediaQuery)
          ],
        ),
      ),
    );
  }
}
