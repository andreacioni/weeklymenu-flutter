import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:provider/provider.dart';

import './meal_head.dart';
import '../../models/meals.dart';
import '../../models/recipe.dart';
import './recipe_title.dart';
import '../../providers/menus_provider.dart';

class MenuPage extends StatelessWidget {
  final DateTime _day;
  
  MenuPage(this._day);

  @override
  Widget build(BuildContext context) {
    var _meals = Provider.of<MenusProvider>(context).groupByMeal(_day);
    return Column(
      children: <Widget>[
        Expanded(
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 1,
            child: ListView(
              padding: EdgeInsets.all(10),
              children: _meals.entries.map((meal) => StickyHeader(
                  header: MealHead(meal.key.value),
                  content: RecipeTile(meal.value),
                )).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
