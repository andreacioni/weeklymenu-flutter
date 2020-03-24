import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:provider/provider.dart';

import './meal_head.dart';
import '../../models/enums/meals.dart';
import '../../models/recipe.dart';
import './recipe_title.dart';
import '../../providers/menus_provider.dart';
import '../../providers/recipes_provider.dart';

class MenuPage extends StatefulWidget {
  final DateTime _day;

  MenuPage(this._day);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool _isLoading = true;

  @override
  void initState() {
    Provider.of<MenusProvider>(context, listen: false)
        .fetchDailyMenu(widget._day)
        .then((_) => setState(() => _isLoading = false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
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
                    children: Provider.of<MenusProvider>(context)
                        .getDailyMenuByMeal(widget._day)
                        .entries
                        .map((meal) => StickyHeader(
                              header: MealHead(meal.key.value),
                              content: RecipeTile(meal.value
                                  .map((recipeId) =>
                                      Provider.of<RecipesProvider>(
                                        context,
                                        listen: false,
                                      ).getById(recipeId))
                                  .toList()),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          );
  }
}
