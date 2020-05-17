import 'package:flutter/material.dart';
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

  Widget _buildPageBody(BuildContext context) {
    final _stickyHeaderMeal = Provider.of<MenusProvider>(context)
        .getDailyMenuByMeal(widget._day)
        .entries
        .map(_buildStickyHeaderFromMeal)
        .expand((i) => i) //Flatten a list of lists
        .toList();

    return Expanded(
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 1,
        child: _stickyHeaderMeal.isEmpty
            ? _buildEmptyMealBackground()
            : CustomScrollView(
                slivers: _stickyHeaderMeal,
              ),
      ),
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
        Container(
          width: double.infinity,
          child: Text(
            'No Menu Defined Here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: _textColor,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        FlatButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            'ADD RECIPE',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  List<Widget> _buildStickyHeaderFromMeal(
      MapEntry<Meal, List<String>> mealEntry) {
    /* return SliverAppBar(
      header: MealHead(mealEntry.key.value),
      content: buildRecipeTilesColumn(mealEntry),
    ); */

    return <Widget>[
      SliverAppBar(
        primary: false,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          ButtonTheme(
            minWidth: 5,
            height: 5,
            child: FlatButton(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.add),
              onPressed: () {},
              shape: CircleBorder(),
            ),
          ),
          ButtonTheme(
            minWidth: 5,
            height: 5,
            child: FlatButton(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.close),
              onPressed: () {},
              shape: CircleBorder(),
            ),
          ),
          ButtonTheme(
            minWidth: 5,
            height: 5,
            child: FlatButton(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.replay),
              onPressed: () {},
              shape: CircleBorder(),
            ),
          ),
        ],
        elevation: 0,
        pinned: true,
        backgroundColor: Colors.white,
        title: Text(
          mealEntry.key.value,
          textAlign: TextAlign.left,
        ),
      ),
      _buildRecipeTilesColumn(mealEntry),
    ];
  }

  Widget _buildRecipeTilesColumn(MapEntry<Meal, List<String>> mealEntry) {
    final recipes = mealEntry.value
        .map((recipeId) => Provider.of<RecipesProvider>(
              context,
              listen: false,
            ).getById(recipeId))
        .toList();

    return SliverList(
      delegate: SliverChildListDelegate(
        recipes
            .map(
              (recipe) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: RecipeTile(recipe),
              ),
            )
            .toList(),
      ),
    );
  }
}
