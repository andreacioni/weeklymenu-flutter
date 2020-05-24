import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../recipe_view/recipe_view.dart';

import '../../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe _recipe;
  final Function onLongPress;
  final Function onTap;
  final Object heroTagValue;
  final BorderSide borderSide;
  final Color color;

  RecipeCard(this._recipe,
      {this.onLongPress,
      this.onTap,
      this.heroTagValue,
      this.borderSide = BorderSide.none,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: borderSide,
      ),
      color: color,
      child: ListTile(
        onLongPress: onLongPress,
        onTap: onTap,
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
      ),
    );
  }
}
