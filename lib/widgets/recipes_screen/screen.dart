import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals/utils.dart';
import '../../providers/recipes_provider.dart';
import '../app_bar.dart';
import '../menu_page/recipe_title.dart';

class RecipesScreen extends StatefulWidget {
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  bool _searchModeEnabled;
  String _searchText;

  @override
  void initState() {
    _searchModeEnabled = false;
    _searchText = "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<RecipesProvider>(context).getRecipes;
    
    recipes.removeWhere((recipe) => !stringContains(recipe.name, _searchText));
    
    return Column(
      children: <Widget>[
        _buildAppBar(context),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemBuilder: (_, index) => RecipeTile(recipes[index]),
              itemCount: recipes.length,
            ),
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {

    if(_searchModeEnabled) {
      _searchText = "";
    }

    return BaseAppBar(
      title: _searchModeEnabled == false
          ? Text('Recipes')
          : TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
              ),
              onChanged: (text) => setState(() => _searchText = text),
            ),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 30.0,
          color: Colors.black,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: <Widget>[
        _searchModeEnabled == false
            ? IconButton(
                icon: Icon(Icons.search),
                onPressed: () => setState(() => _searchModeEnabled = true),
              )
            : IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => setState(() => _searchModeEnabled = false),
              ),
      ],
    );
  }
}
