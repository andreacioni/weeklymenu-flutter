import 'package:flutter/material.dart';

class SelectedRecipesListView extends StatefulWidget {
  final Function(String) onRecipeRemoved;
  final List<String> _recipesList;

  SelectedRecipesListView(this._recipesList, {this.onRecipeRemoved});

  @override
  _SelectedRecipesListViewState createState() =>
      _SelectedRecipesListViewState();
}

class _SelectedRecipesListViewState extends State<SelectedRecipesListView> {

  void addSelectedRecipe(String recipe) {
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
                title: Text(recipe),
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
