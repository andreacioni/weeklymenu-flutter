import 'package:flutter/material.dart';
import '../recipe_view/recipe_view.dart';

import '../../models/recipe.dart';

class RecipeTile extends StatelessWidget {

  final List<Recipe> _recipes;

  RecipeTile(this._recipes);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _recipes.map((recipe) => Card(
          child: ListTile(
            leading: Hero(tag: 'recipe', child: FlutterLogo(size: 72.0)),
            title: Text(recipe.name),
            subtitle:
                Text('A sufficiently long subtitle warrants three lines.'),
            trailing: Icon(Icons.more_vert),
            isThreeLine: true,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => RecipeView(recipe))),
          ),
        ),).toList(),
    );
  }
}
