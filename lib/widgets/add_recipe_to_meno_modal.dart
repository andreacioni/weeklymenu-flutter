import 'package:flutter/material.dart';

import './meal_dropdown.dart';
import './recipe_selection_text_field.dart';
import './selected_recipes_listview.dart';

class AddRecipeToMenuModal extends StatefulWidget {
  @override
  _AddRecipeToMenuModalState createState() => _AddRecipeToMenuModalState();
}

class _AddRecipeToMenuModalState extends State<AddRecipeToMenuModal> {

  bool _almostOneRecipeSelected = false;

  List<String> menuListToRecipeList() {
    return ["Pici aglio e olio", "Spaghetti alla matriciana", "Uovo sodo"];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            MealDropdown(),
            RecipeSelectionTextField(menuListToRecipeList(), () {}),
            
          ],
        ),
        SelectedRecipesListView(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text("FINISH"),
              onPressed: !_almostOneRecipeSelected ? null : () {},
            ),
          ],
        ),
      ],
    );
  }
}
