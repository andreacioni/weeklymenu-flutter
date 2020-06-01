import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../globals/constants.dart' as constants;
import '../../models/menu.dart';
import '../../models/enums/meals.dart';
import '../menu_editor/screen.dart';

import '../../presentation/custom_icons_icons.dart';
import '../recipes_screen/recipe_card.dart';
import '../../providers/menus_provider.dart';
import '../../providers/recipes_provider.dart';
import '../recipe_view/recipe_view.dart';
import './add_recipe_modal/add_recipe_to_menu_modal.dart';
import '../../globals/utils.dart' as utils;

class MenuCard extends StatelessWidget {
  static final extent = 150.0;
  static final _dateParser = DateFormat('EEEE, MMMM dd');

  final void Function() onTap;

  MenuCard({this.onTap});

  @override
  Widget build(BuildContext context) {
    final dailyMenu = Provider.of<DailyMenu>(context);

    final isToday = (utils.dateTimeToDate(DateTime.now()) == dailyMenu.day);
    final pastDay = (utils
        .dateTimeToDate(dailyMenu.day)
        .add(Duration(days: 1))
        .isBefore(DateTime.now()));

    final divider = Divider(
      color: Colors.grey.shade500,
      height: 0,
    );

    final padding = EdgeInsets.symmetric(horizontal: 10);

    final rowExtend = (MenuCard.extent - 8) /
        (Meal.values.length + 1); // +1 for the day header

    final primaryColor = pastDay
        ? constants.pastColor
        : (isToday ? constants.todayColor : Colors.amber.shade200);

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
                    _dateParser.format(dailyMenu.day),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (isToday)
                    Container(
                      child: Text('TODAY'),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                      ),
                      padding: EdgeInsets.all(5),
                    ),
                  if (pastDay)
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
                  Icon(Icons.local_cafe, color: primaryColor.withOpacity(0.5)),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    Meal.Breakfast.value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black45),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  _recipesRow(context, dailyMenu.getByMeal(Meal.Breakfast)),
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
                  Icon(Icons.fastfood, color: primaryColor.withOpacity(0.5)),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    Meal.Lunch.value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black45),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  _recipesRow(context, dailyMenu.getByMeal(Meal.Lunch)),
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
                  Icon(Icons.local_bar, color: primaryColor.withOpacity(0.5)),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    Meal.Dinner.value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black45),
                  ),
                  SizedBox(
                    width: 28,
                  ),
                  _recipesRow(context, dailyMenu.getByMeal(Meal.Dinner)),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _recipesRow(BuildContext context, List<String> recipesIds) {
    return Expanded(
      child: Row(
        children: <Widget>[
          if (recipesIds == null || recipesIds.isEmpty)
            Text(
              "No recipes defined",
              textAlign: TextAlign.right,
              style:
                  TextStyle(fontStyle: FontStyle.italic, color: Colors.black45),
            ),
          if (recipesIds != null && recipesIds.isNotEmpty)
            _listToText(context, recipesIds)
        ],
      ),
    );
  }

  Widget _listToText(BuildContext context, List<String> mealEntry) {
    final recipes = mealEntry
        .map((recipeId) => Provider.of<RecipesProvider>(
              context,
              listen: false,
            ).getById(recipeId))
        .toList();

    return Expanded(
      child: Text(
        recipes.join(', '),
        style: TextStyle(fontStyle: FontStyle.normal, color: Colors.black),
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        maxLines: 1,
      ),
    );
  }
}
