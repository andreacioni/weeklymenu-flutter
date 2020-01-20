import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

import '../../models/recipe.dart';

import './expandable_widget.dart';
import './recipe_app_bar.dart';
import './editable_text_field.dart';

class RecipeView extends StatefulWidget {
  final Recipe _recipe;

  RecipeView(this._recipe);

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  bool _editEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          RecipeAppBar(
            widget._recipe,
            editModeEnabled: _editEnabled,
            onRecipeEditEnabled: (editEnabled) => setState(() {
              _editEnabled = editEnabled;
            }),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 5,
              ),
              EditableTextField(
                "A delicious salad",
                _editEnabled,
                hintText: "Description",
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
