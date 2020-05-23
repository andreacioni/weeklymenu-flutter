import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/enums/meals.dart';
import '../../presentation/custom_icons_icons.dart';
import './recipe_card.dart';
import '../../providers/menus_provider.dart';
import '../../providers/recipes_provider.dart';
import '../recipe_view/recipe_view.dart';

class MenuPage extends StatefulWidget {
  final DateTime _day;

  MenuPage(this._day);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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
            return _buildPageBody(context);
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
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
    return <Widget>[
      SliverAppBar(
        primary: false,
        automaticallyImplyLeading: false,
        elevation: 0,
        pinned: true,
        backgroundColor: Colors.white,
        title: Text(
          mealEntry.key.value,
          textAlign: TextAlign.left,
        ),
        actions: <Widget>[
          ButtonTheme(
            minWidth: 5,
            height: 5,
            child: FlatButton(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.add),
              onPressed: () => _addRecipeToMeal(mealEntry.key),
              shape: CircleBorder(),
            ),
          ),
          ButtonTheme(
            minWidth: 5,
            height: 5,
            child: FlatButton(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.close),
              onPressed: () => _removeWholeMeal(mealEntry.key),
              shape: CircleBorder(),
            ),
          ),
        ],
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
    final heroTag = UniqueKey();

    return SliverList(
      delegate: SliverChildListDelegate(
        recipes
            .map(
              (recipe) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: RecipeCard(
                  recipe,
                  heroTagValue: heroTag,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => ChangeNotifierProvider.value(
                        value: recipe,
                        child: RecipeView(heroTag: heroTag),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  void _addRecipeToMeal(Meal meal) async {
    showDialog(context: context, builder: (ctx) => AlertDialog());
  }

  void _removeWholeMeal(Meal meal) async {
    var confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('All recipe associated to this meal will be lost'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('NO'),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('YES'),
          ),
        ],
      ),
    );

    if (confirm) {
      Provider.of<MenusProvider>(context, listen: false)
          .removeDayMeal(widget._day, meal);
    }
  }
}
