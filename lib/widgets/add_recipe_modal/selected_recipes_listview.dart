import 'package:flutter/material.dart';

import '../../models/recipe.dart';

class SelectedRecipesListView extends StatefulWidget {
  final Function(Recipe) onRecipeRemoved;
  final List<Recipe> _recipesList;

  SelectedRecipesListView(this._recipesList, {this.onRecipeRemoved});

  @override
  _SelectedRecipesListViewState createState() =>
      _SelectedRecipesListViewState();
}

class _SelectedRecipesListViewState extends State<SelectedRecipesListView> {

  void addSelectedRecipe(Recipe recipe) {
    setState(() {
      widget._recipesList.add(recipe);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: widget._recipesList
            .map(
              (recipe) => ListTile(
                title: Text(recipe.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      widget._recipesList.removeWhere((r) => r == recipe);
                    });
                    widget.onRecipeRemoved(recipe);
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
