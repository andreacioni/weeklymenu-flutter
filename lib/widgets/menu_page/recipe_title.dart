import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../recipe_view/recipe_view.dart';

import '../../models/recipe.dart';

class RecipeTile extends StatelessWidget {
  final Recipe _recipe;

  RecipeTile(this._recipe);

  @override
  Widget build(BuildContext context) {
    final heroTagValue = UniqueKey();
    return Card(
      child: ListTile(
        leading: Hero(
          tag: heroTagValue,
          child: _recipe.imgUrl != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(_recipe.imgUrl),
                  radius: 30,
                )
              : Image.asset(
                  "assets/icons/book.png",
                  scale: 0.5,
                ),
        ),
        title: Text(_recipe.name),
        subtitle: Text('A sufficiently long subtitle warrants three lines.'),
        trailing: Icon(Icons.more_vert),
        isThreeLine: true,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => ChangeNotifierProvider.value(
              value: _recipe,
              child: RecipeView(heroTagValue),
            ),
          ),
        ),
      ),
    );
  }
}
