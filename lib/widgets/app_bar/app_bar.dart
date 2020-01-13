import 'package:flutter/material.dart';

import '../../models/recipe.dart';

class WMAppBar extends AppBar {
  static const _title = const Text(
    'Weekly Menu',
    style: TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Arial'),
  );

  final bool _selectionMode;
  final DateTime day;
  final List<Recipe> selectedRecipes;

  WMAppBar(this._selectionMode, {this.day, this.selectedRecipes})
      : assert(_selectionMode ? day != null && selectedRecipes != null : true), //TODO improve
        super(
          centerTitle: true,
          elevation: 5.0,
          title: FlatButton(
            child: _title,
            onPressed: () => {},
          ),
          leading: const IconButton(
            icon: Icon(
              Icons.menu,
              size: 30.0,
              color: Colors.black,
            ),
            onPressed: null,
          ),
          actions: const <Widget>[
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                size: 30.0,
                color: Colors.black,
              ),
              onPressed: null,
            ),
          ],
        );
}
