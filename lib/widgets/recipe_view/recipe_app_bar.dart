import 'package:flutter/material.dart';

import '../../models/recipe.dart';

class RecipeAppBar extends StatelessWidget {
  final editModeEnabled;
  final Recipe _recipe;
  final Function(bool) onRecipeEditEnabled;

  RecipeAppBar(this._recipe, {this.editModeEnabled, this.onRecipeEditEnabled});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 150.0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(_recipe.name),
        background:
            Hero(tag: _recipe.name, child: FlutterLogo(size: 72.0)),
      ),
      actions: <Widget>[
        if (!editModeEnabled)
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              onRecipeEditEnabled(!editModeEnabled);
            },
          ),
        if (editModeEnabled)
          IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                onRecipeEditEnabled(!editModeEnabled);
              }),
        if (editModeEnabled)
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                onRecipeEditEnabled(!editModeEnabled);
              })
      ],
    );
  }
}