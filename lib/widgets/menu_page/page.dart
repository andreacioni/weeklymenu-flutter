import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:provider/provider.dart';

import './meal_head.dart';
import '../../models/enums/meals.dart';
import '../../presentation/custom_icons_icons.dart';
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
        : _buildPageBody(context);
  }

  Column _buildPageBody(BuildContext context) {
    final _stickyHeaderMeal = Provider.of<MenusProvider>(context)
        .getDailyMenuByMeal(widget._day)
        .entries
        .map(_buildStickyHeaderFromMeal)
        .toList();

    return Column(
      children: <Widget>[
        Expanded(
          //child: Card(
            //color: Colors.white,
            //shape: RoundedRectangleBorder(
            //  borderRadius: BorderRadius.circular(10),
            //),
            //elevation: 1,
            child: _stickyHeaderMeal.isEmpty
                ? _buildEmptyMealBackground()
                : ListView(
                    padding: EdgeInsets.all(10),
                    children: _stickyHeaderMeal,
                  ),
         // ),
        ),
      ],
    );
  }

  Widget _buildEmptyMealBackground() {
    final _textColor = Colors.grey.shade300;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          CustomIcons.dinner,
          size: 150,
          color: _textColor,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'No menu for this day',
          style: TextStyle(
            fontSize: 25,
            color: _textColor,
          ),
        )
      ],
    );
  }

  Widget _buildStickyHeaderFromMeal(MapEntry<Meal, List<String>> mealEntry) {
    return StickyHeader(
      header: MealHead(mealEntry.key.value),
      content: buildRecipeTilesColumn(mealEntry),
    );
  }

  Widget buildRecipeTilesColumn(MapEntry<Meal, List<String>> mealEntry) {
    final recipes = mealEntry.value
        .map((recipeId) => Provider.of<RecipesProvider>(
              context,
              listen: false,
            ).getById(recipeId))
        .toList();

    return Column(
      children: recipes
          .map(
            (recipe) => RecipeTile(recipe),
          )
          .toList(),
    );
  }
}
