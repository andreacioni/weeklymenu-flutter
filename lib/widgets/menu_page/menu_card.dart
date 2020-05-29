import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../globals/constants.dart' as constants;
import '../../models/menu.dart';
import '../../models/enums/meals.dart';
import '../../presentation/custom_icons_icons.dart';
import '../recipes_screen/recipe_card.dart';
import '../../providers/menus_provider.dart';
import '../../providers/recipes_provider.dart';
import '../recipe_view/recipe_view.dart';
import './add_recipe_modal/add_recipe_to_menu_modal.dart';
import '../../globals/utils.dart' as utils;

class MenuCard extends StatefulWidget {
  static final extent = 150.0;

  final DateTime _day;
  final Map<Meal, List<String>> _menuByMeal;

  final void Function() onTap;

  MenuCard(this._day, this._menuByMeal, {this.onTap});

  @override
  _MenuCardState createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  static final _dateParser = DateFormat('EEEE, MMMM dd');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<MenusProvider>(context, listen: false)
          .fetchDailyMenu(widget._day),
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return _buildListBody(
                MenusProvider.organizeMenuListByMeal(snapshot.data));
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  Widget _buildListBody(Map<Meal, List<String>> menuByMeal) {
    final isToday = (utils.dateTimeToDate(DateTime.now()) == widget._day);
    final pastDay = (utils
        .dateTimeToDate(widget._day)
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
        : (isToday ? constants.todayColor : Theme.of(context).primaryColor);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      splashColor: primaryColor.withOpacity(0.2),
      onTap: widget.onTap,
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
              color: primaryColor.withOpacity(0.4),
            ),
            child: SizedBox(
              height: rowExtend,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _dateParser.format(widget._day),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (isToday) Text('TODAY'),
                  if (pastDay) Text('PAST')
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
                  Icon(Icons.local_cafe, color: primaryColor.withOpacity(0.3)),
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
                  _recipesRow(menuByMeal[Meal.Breakfast]),
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
                  Icon(Icons.fastfood, color: primaryColor.withOpacity(0.3)),
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
                  _recipesRow(menuByMeal[Meal.Lunch]),
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
                  Icon(Icons.local_bar, color: primaryColor.withOpacity(0.3)),
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
                  _recipesRow(menuByMeal[Meal.Dinner]),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _recipesRow(List<String> recipesIds) {
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
            _listToText(recipesIds)
        ],
      ),
    );
  }

  Widget _listToText(List<String> mealEntry) {
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
