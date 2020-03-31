import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipes_provider.dart';
import '../app_bar.dart';
import '../menu_page/recipe_title.dart';

class RecipesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<RecipesProvider>(context).getRecipes;
    return Column(
      children: <Widget>[
        _buildAppBar(),
        Expanded(
          child: ListView.builder(
            itemBuilder: (_, index) => RecipeTile(recipes[index]),
            itemCount: recipes.length,
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return BaseAppBar(
      title: Text('Recipes'),
      actions: const <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            size: 30.0,
            color: Colors.black,
          ),
          onPressed: null,
        ),
      ],
    );
  }
}
