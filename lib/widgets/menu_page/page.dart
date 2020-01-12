import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

import './meal_head.dart';
import '../../models/meals.dart';
import '../../models/recipe.dart';
import './recipe_title.dart';

class MenuPage extends StatelessWidget {
  final Map<Meal, List<Recipe>> _meals;

  MenuPage(this._meals);

  @override
  Widget build(BuildContext context) {
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
