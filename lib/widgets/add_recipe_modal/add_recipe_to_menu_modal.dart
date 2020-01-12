import 'package:flutter/material.dart';

import './meal_dropdown.dart';
import './recipe_selection_text_field.dart';
import './selected_recipes_listview.dart';

class AddRecipeToMenuModal extends StatefulWidget {
  final Function(List<String>) onSelectionEnd;

  AddRecipeToMenuModal({this.onSelectionEnd}) : assert (onSelectionEnd != null);

  @override
  _AddRecipeToMenuModalState createState() => _AddRecipeToMenuModalState();
}

class _AddRecipeToMenuModalState extends State<AddRecipeToMenuModal> {

  List<String> _selectedRecipes = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            MealDropdown(),
            RecipeSelectionTextField(
              _selectedRecipes,
              onRecipeSelected: (recipe) {
                setState(() {
                  _selectedRecipes.add(recipe);
                });
              }),
          ],
        ),
        SelectedRecipesListView(
          _selectedRecipes,
          onRecipeRemoved: (recipe) {
            setState(() {
              _selectedRecipes.removeWhere((r) => r == recipe);
            });
          }
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text("FINISH"),
              onPressed: _selectedRecipes.isEmpty ? null : () {
                widget.onSelectionEnd(_selectedRecipes);
                Navigator.of(context).pop();
              } ,
            ),
          ],
        ),
      ],
    );
  }
}
