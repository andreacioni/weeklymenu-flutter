import 'package:flutter/material.dart';

import '../../models/recipe.dart';

class RecipeAppBar extends StatelessWidget {
  final editModeEnabled;
  final Recipe _recipe;
  final Object _heroTag;
  final Function(bool) onRecipeEditEnabled;

  RecipeAppBar(this._recipe, this._heroTag,
      {this.editModeEnabled, this.onRecipeEditEnabled});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: _recipe.imgUrl != null ? 200.0 : null,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Container(
          color: Colors.black.withOpacity(0.4),
          padding: EdgeInsets.all(3),
          child: Text(
            _recipe.name,
            style: TextStyle(color: Colors.white),
          ),
        ),
        background: _recipe.imgUrl != null ? Hero(
          tag: _heroTag,
          child:Image.network(
                  _recipe.imgUrl,
                  fit: BoxFit.fitWidth,
                ),
        ) : null,
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
