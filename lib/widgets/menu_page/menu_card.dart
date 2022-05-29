import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

const MENU_CARD_ROUNDED_RECT_BORDER = const Radius.circular(10);

//TODO dynamic Meal label (don't want to write new code for every new Meal)
class MenuCard extends HookConsumerWidget {
  static final extent = 150.0;

  static final _dateParser = DateFormat('EEEE, MMMM dd');

  final DailyMenuNotifier dailyMenuNotifier;
  final void Function()? onTap;

  MenuCard(this.dailyMenuNotifier, {this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyMenu = useStateNotifier(dailyMenuNotifier);

    final divider = Divider(
      color: Colors.grey.shade500,
      height: 0,
    );

    final padding = EdgeInsets.symmetric(horizontal: 10);

    final rowExtend = (MenuCard.extent - 8) /
        (Meal.values.length + 1); // +1 for the day header

    final primaryColor = dailyMenu.isPast
        ? constants.pastColor
        : (dailyMenu.isToday ? constants.todayColor : Colors.amber.shade200);

    Widget _recipesRow(Meal meal) {
      final originDailyMenuNotifier =
          ref.read(homePageModalBottomSheetDailyMenuNotifierProvider);
      final recipesIds = dailyMenu.getRecipeIdsByMeal(meal);

      //TODO recipe rows could be moved to a new separated widget and use a provided Menu to improve performance (changes to a menu/meal won't the entire card)
      return Expanded(
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
            await dailyMenuNotifier.updateMenu(destinationMenu.copyWith(
                recipes: [
                  ...destinationMenu.recipes,
                  ...recipeIds
                ]).was(destinationMenu));
          }

          mealRecipeMap.forEach((meal, recipes) {
            originDailyMenuNotifier?.removeRecipesFromMeal(meal, recipes);
          });
        }, builder: (context, _, __) {
          return Row(
            children: <Widget>[
              if (recipesIds.isEmpty)
                Text(
                  "No recipes defined",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.black45),
                ),
              if (recipesIds.isNotEmpty) MenuRecipesText(recipesIds)
            ],
          );
        }),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      splashColor: primaryColor.withOpacity(0.6),
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(children: <Widget>[
          //HEADER
          Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: primaryColor,
            ),
            child: SizedBox(
              height: rowExtend,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    dailyMenu.day.format(_dateParser),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (dailyMenu.isToday)
                    Container(
                      child: Text('TODAY'),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                      ),
                      padding: EdgeInsets.all(5),
                    ),
                  if (dailyMenu.isPast)
                    Icon(
                      Icons.archive,
                      color: Colors.black,
                    ),
                ],
              ),
            ),
          ),
          divider,
          //BREAKFAST
          Container(
            padding: padding,
            color: primaryColor.withOpacity(0.1),
            child: SizedBox(
              height: rowExtend,
              child: Row(
                children: <Widget>[
                  Icon(Meal.Dinner.icon, color: primaryColor.withOpacity(0.5)),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    Meal.Breakfast.value!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black45),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  _recipesRow(Meal.Breakfast),
                ],
              ),
            ),
          ),
          divider,
          //Lunch
          Container(
            padding: padding,
            color: primaryColor.withOpacity(0.1),
            child: SizedBox(
              height: rowExtend,
              child: Row(
                children: <Widget>[
                  Icon(Meal.Lunch.icon, color: primaryColor.withOpacity(0.5)),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    Meal.Lunch.value!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black45),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  _recipesRow(Meal.Lunch),
                ],
              ),
            ),
          ),
          divider,
          //DINNER
          Container(
            padding: padding,
            color: primaryColor.withOpacity(0.1),
            child: SizedBox(
              height: rowExtend,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(Meal.Dinner.icon, color: primaryColor.withOpacity(0.5)),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    Meal.Dinner.value!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black45),
                  ),
                  SizedBox(
                    width: 28,
                  ),
                  _recipesRow(Meal.Dinner),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class MenuRecipesText extends ConsumerWidget {
  final List<String> _recipesIds;

  MenuRecipesText(this._recipesIds, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterDataStateBuilder<List<Recipe>>(
        state: ref.recipes.watchAll(),
        builder: (context, recipes) {
          List<String> recipesNames = <String>[];
          for (String recipeId in _recipesIds) {
            final recipe = recipes.firstWhereOrNull((r) => r.id == recipeId);
            recipesNames.add(recipe?.name ?? '');
          }
          return _buildTextEntry(recipesNames);
        });
  }

  Widget _buildTextEntry(List<String> recipesNames) {
    return Expanded(
      child: Text(
        (recipesNames..removeWhere((e) => e.isEmpty)).join(', '),
        style: TextStyle(fontStyle: FontStyle.normal, color: Colors.black),
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        maxLines: 1,
      ),
    );
  }
}
