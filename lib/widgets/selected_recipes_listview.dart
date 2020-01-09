import 'package:flutter/material.dart';

class SelectedRecipesListView extends StatefulWidget {
  @override
  _SelectedRecipesListViewState createState() =>
      _SelectedRecipesListViewState();
}

class _SelectedRecipesListViewState extends State<SelectedRecipesListView> {
  List<String> _selectedRecipesList = ["AGGGG"];

  void addSelectedRecipe(String recipe) {
    setState(() {
      _selectedRecipesList.add(recipe);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: _selectedRecipesList
            .map(
              (recipe) => ListTile(
                title: Text(recipe),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {},
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
