import 'package:flutter/material.dart';
import '../recipe_view/recipe_view.dart';

import '../../models/recipe.dart';

class RecipeTile extends StatelessWidget {
  final List<Recipe> _recipes;

  RecipeTile(this._recipes);

  Widget _createCardForRecipe(BuildContext context, Recipe recipe) {
    final heroTagValue = UniqueKey();
    return Card(
      child: ListTile(
        leading: Hero(
          tag: heroTagValue,
          child: recipe.imgUrl != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(recipe.imgUrl),
                  radius: 30,
                )
              : Image.asset(
                  "assets/icons/book.png",
                  scale: 0.5,
                ),
        ),
        title: Text(recipe.name),
        subtitle: Text('A sufficiently long subtitle warrants three lines.'),
        trailing: Icon(Icons.more_vert),
        isThreeLine: true,
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => RecipeView(recipe, heroTagValue))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _recipes
          .map(
            (recipe) => _createCardForRecipe(context, recipe),
          )
          .toList(),
    );
  }
}
