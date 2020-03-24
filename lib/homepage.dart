import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import './globals/constants.dart';
import './models/recipe.dart';
import './widgets/add_recipe_modal/add_recipe_to_menu_modal.dart';
import './widgets/app_bar/app_bar.dart';
import './widgets/menu_page/page.dart';
import './providers/ingredients_provider.dart';
import './providers/recipes_provider.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;
  bool _selectionMode = false;
  DateTime _day;
  List<Recipe> _selectedRecipes = List();

  bool _ingredientLoaded = false;
  bool _recipesLoaded = false;

  _HomePageState();

  @override
  void initState() {
    var pageIndex = (PAGEVIEW_LIMIT_DAYS / 2).truncate();
    _pageController = new PageController(initialPage: pageIndex);

    var now = DateTime.now();
    _day = DateTime(now.year, now.month, now.day);

    Provider.of<IngredientsProvider>(context, listen: false)
        .fetchIngredients()
        .then((_) => setState(() => _ingredientLoaded = true));
    Provider.of<RecipesProvider>(context, listen: false)
        .fetchRecipes()
        .then((_) => setState(() => _recipesLoaded = true));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuAppBar(_selectionMode,
          day: _day, selectedRecipes: _selectedRecipes),
      floatingActionButton: !_selectionMode
          ? FloatingActionButton.extended(
              elevation: 4.0,
              icon: const Icon(Icons.add),
              label: const Text('ADD'),
              onPressed: () {
                _openAddRecipeModal(context);
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(context),
      body: (!_recipesLoaded || !_ingredientLoaded)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: double.infinity,
                  width: double.infinity,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: PageView.builder(
                    itemBuilder: (ctx, index) => MenuPage(_day),
                    onPageChanged: _setDayNameInBottomAppBar,
                    controller: _pageController,
                  ),
                )
              ],
            ),
    );
  }

  BottomAppBar _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: !_selectionMode ? () => _selectDate(context) : null,
              ),
              GestureDetector(
                child: Text(DateFormat.MMMEd().format(_day)),
                onTap: !_selectionMode ? () => _selectDate(context) : null,
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: !_selectionMode ? () {} : null,
          )
        ],
      ),
    );
  }

  void _setDayNameInBottomAppBar(int newPageIndex) {
    print("page changed to $newPageIndex");
    setState(() {
      var now = DateTime.now();
      _day = DateTime(now.year, now.month, now.day).add(
          Duration(days: newPageIndex - (PAGEVIEW_LIMIT_DAYS / 2).truncate()));
    });
  }

  void _openAddRecipeModal(ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => Padding(
        padding: EdgeInsets.all(15),
        child: AddRecipeToMenuModal(
          onSelectionEnd: (_) {},
        ),
      ),
    );
  }

  void _selectDate(ctx) async {
    showDatePicker(
      context: ctx,
      initialDate: _day,
      firstDate: DateTime.now()
          .subtract(Duration(days: (PAGEVIEW_LIMIT_DAYS / 2).truncate())),
      lastDate: DateTime.now()
          .add((Duration(days: (PAGEVIEW_LIMIT_DAYS / 2).truncate()))),
    ).then((selectedDate) {
      setState(() {
        int oldPageIndex = _pageController.page.truncate();
        if (selectedDate.compareTo(_day) != 0) {
          print(
              "jump length: ${selectedDate.difference(_day).inDays}, from page: ${oldPageIndex} (${_day} to ${selectedDate})");
          int newPageIndex =
              oldPageIndex + selectedDate.difference(_day).inDays;
          print("jumping to page: $newPageIndex");
          _pageController.jumpToPage(newPageIndex);
        }
      });
      return selectedDate;
    });
  }
}
