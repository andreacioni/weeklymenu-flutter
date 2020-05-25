import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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

  MenuCard(this._day);

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
            return _abc();
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  Widget _abc() {
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
        ? Colors.indigo
        : (isToday ? Colors.green : Theme.of(context).primaryColor);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      splashColor: primaryColor.withOpacity(0.2),
      onTap: () {},
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
              color: isToday
                  ? primaryColor.withOpacity(0.4)
                  : primaryColor.withOpacity(0.4),
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
                ],
              ),
            ),
          ),
          divider,
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
                ],
              ),
            ),
          ),
          divider,
          Container(
            padding: padding,
            color: primaryColor.withOpacity(0.1),
            child: SizedBox(
              height: rowExtend,
              child: Row(
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
                ],
              ),
            ),
          ),
        ]),
      ),
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
          onPressed: _openAddRecipeModal,
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
        title: Text(mealEntry.key.value),
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
      SliverList(delegate: SliverChildListDelegate.fixed(<Widget>[Divider()])),
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

  void _openAddRecipeModal() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: AddRecipeToMenuModal(
          onSelectionEnd: (_) {},
        ),
      ),
    );
  }
}
