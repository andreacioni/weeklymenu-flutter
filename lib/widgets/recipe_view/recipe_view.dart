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
                widget._recipe.description,
                editEnabled: _editEnabled,
                hintText: "Description",
              ),
              SizedBox(
                height: 5,
              ),
            ]),
          ),
          SliverGrid.count(
            crossAxisCount: 3,
            children: <Widget>[
              EditableTextField(
                "2",
                editEnabled: _editEnabled,
                icon: Icon(Icons.people),
                hintText: "Servs",
              ),
              EditableTextField(
                "12 min",
                editEnabled: _editEnabled,
                icon: Icon(Icons.timer),
              ),
              EditableTextField(
                "3/5",
                editEnabled: _editEnabled,
                icon: Icon(Icons.star),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Text("Ingredients"),
              ...widget._recipe.ingredients
                  .map((ing) => ListTile(
                        title: Text(ing.name),
                      ))
                  .toList(),
              EditableTextField("", editEnabled: _editEnabled, hintText: "Notes"),
            ]),
          ),
        ],
      ),
    );
  }
}
