import 'package:flutter/material.dart';

import '../../models/recipe.dart';

class RecipeView extends StatefulWidget {
  final Recipe _recipe;

  RecipeView(this._recipe);

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {

  bool _editDisabled = true;

  void _swapEditDisabled() {
    setState(() {
                _editDisabled = !_editDisabled;
              });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 150.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(widget._recipe.name),
            background: Hero(tag: 'recipe', child: FlutterLogo(size: 72.0)),
          ),
          actions: <Widget>[
            if(_editDisabled) IconButton(icon: Icon(Icons.edit), onPressed: () => _swapEditDisabled(),),
            if(!_editDisabled) IconButton(icon: Icon(Icons.check), onPressed: () => _swapEditDisabled(),)
          ],
        ),
        
      ],
    );
  }
}