import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './meal_dropdown.dart';
import './recipe_selection_text_field.dart';
import './selected_recipes_listview.dart';
import '../../../models/recipe.dart';
import '../../../providers/recipes_provider.dart';

class AddRecipeToMenuModal extends StatefulWidget {
  final Function(List<Recipe>) onSelectionEnd;

  AddRecipeToMenuModal({this.onSelectionEnd}) : assert(onSelectionEnd != null);

  @override
  _AddRecipeToMenuModalState createState() => _AddRecipeToMenuModalState();
}

class _AddRecipeToMenuModalState extends State<AddRecipeToMenuModal> {
  List<Recipe> _selectedRecipes = [];

  @override
  Widget build(BuildContext context) {
    List<RecipeOriginator> suggestibleRecipes =
        Provider.of<RecipesProvider>(context, listen: false).recipes;

    suggestibleRecipes.removeWhere((r) => _selectedRecipes.contains(r));

    return Column(
      mainAxisSize: MainAxisSize.min,
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            MealDropdown(),
            RecipeSelectionTextField(
              suggestibleRecipes,
              onRecipeSelected: (recipe) {
                setState(() {
                  _selectedRecipes.add(recipe);
                });
              },
            ),
          ],
        ),
        SelectedRecipesListView(
          _selectedRecipes,
          onRecipeRemoved: (recipe) {
            setState(() {
              _selectedRecipes.removeWhere((r) => r == recipe);
            });
          },
        ),
      ],
    );
  }
}
