import 'dart:ui';

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
import 'add_recipe_dialog.dart';

const MENU_CARD_ROUNDED_RECT_BORDER = const Radius.circular(10);

//TODO dynamic Meal label (don't want to write new code for every new Meal)
class MenuCard extends HookConsumerWidget {
  static final _dialogDateParser = DateFormat('EEEE, dd');
  static final _appBarDateParser = DateFormat('EEE,dd');
  static final _appBarMonthParser = DateFormat('MMM');

  final DailyMenu dailyMenu;
  final void Function()? onTap;

  MenuCard(this.dailyMenu, {this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final divider = Divider(
      color: Colors.grey.shade500,
      height: 0,
    );

    final padding = const EdgeInsets.fromLTRB(10, 5, 0, 0);

    final primaryColor = dailyMenu.isPast
        ? constants.pastColor
        : (dailyMenu.isToday ? constants.todayColor : Colors.amber.shade200);

    Widget _buildMealRecipeMenuSection(Menu? menu) {
      //TODO recipe rows could be moved to a new separated widget
      //and use a provided Menu to improve performance
      //(changes to a menu/meal won't the entire card)
      return MenuContainer(
        menu,
        dailyMenuNotifier: DailyMenuNotifier(dailyMenu),
        padding: padding,
      );
    }

    void _openAddRecipeToDailyMenuDialog() async {
      final Recipe recipe = await showDialog(
          context: context,
          builder: (context) => RecipeSelectionDialog(
              title: _dialogDateParser.format(dailyMenu.day.toDateTime)));

      print(recipe);
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
                      text: dailyMenu.day.format(_appBarDateParser) + ' ',
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
                          text: dailyMenu.day.format(_appBarMonthParser),
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
                    onPressed: _openAddRecipeToDailyMenuDialog,
                    splashRadius: 15.0,
                  ),
                ],
              ),
            ),
          ),
          ...Meal.values
              .map((m) =>
                  _buildMealRecipeMenuSection(dailyMenu.getMenuByMeal(m)))
              .toList()
        ],
      ),
    );
  }
}

class MenuRecipeCard extends ConsumerWidget {
  final String recipeId;

  MenuRecipeCard(this.recipeId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(10);

    return FlutterDataStateBuilder<Recipe>(
        state: ref.recipes.watchOne(recipeId),
        builder: (context, recipe) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            elevation: 3,
            child: InkWell(
              borderRadius: borderRadius,
              highlightColor: theme.primaryColor.withOpacity(0.4),
              splashColor: theme.primaryColor.withOpacity(0.6),
              onTap: () {},
              child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    recipe.name,
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.w700),
                  )),
            ),
          );
        });
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
      child: DragTarget<Map<Meal, List<String>>>(onWillAccept: (mealRecipe) {
        print('on will accept');
        return true;
      }, onAccept: (mealRecipeMap) async {
        print('onAccept - $meal');
        ref.read(menuRecipeSelectionProvider.notifier).clearSelected();

        final recipeIds = mealRecipeMap.values
            .fold<List<String>>(<String>[], (pv, e) => pv..addAll(e));

        if (recipeIds.isEmpty) return;

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

        mealRecipeMap.forEach((meal, recipes) {
          //originDailyMenuNotifier?.removeRecipesFromMeal(meal, recipes);
        });
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
        Expanded(child: MenuRecipeCard(recipeId))
      ],
    );
  }
}
