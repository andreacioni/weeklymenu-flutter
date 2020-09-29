import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:weekly_menu_app/syncronizer/syncro.dart';

import '../../globals/constants.dart' as constants;
import '../../models/menu.dart';
import '../../models/enums/meals.dart';

import '../../providers/recipes_provider.dart';

class MenuCard extends StatelessWidget {
  static final extent = 150.0;
  static final _dateParser = DateFormat('EEEE, MMMM dd');

  final void Function() onTap;

  MenuCard({this.onTap});

  @override
  Widget build(BuildContext context) {
    final dailyMenu = Provider.of<DailyMenu>(context);

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
                    Meal.Breakfast.value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black45),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  _recipesRow(
                      context, dailyMenu.getRecipeIdsByMeal(Meal.Breakfast)),
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
                    Meal.Lunch.value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black45),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  _recipesRow(
                      context, dailyMenu.getRecipeIdsByMeal(Meal.Lunch)),
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
                    Meal.Dinner.value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black45),
                  ),
                  SizedBox(
                    width: 28,
                  ),
                  _recipesRow(
                      context, dailyMenu.getRecipeIdsByMeal(Meal.Dinner)),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _recipesRow(BuildContext context, List<Id> recipesIds) {
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

  Widget _listToText(BuildContext context, List<Id> mealEntry) {
    final recipes = mealEntry
        .map((recipeId) => Provider.of<RecipesProvider>(
              context,
              listen: false,
            ).getById(recipeId).name)
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
