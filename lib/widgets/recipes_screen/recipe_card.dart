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
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: borderSide,
        ),
        color: color,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: <Widget>[
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                      child: _buildImageHeader(_recipe.imgUrl),
                ),
                flex: 2,
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                ),
                flex: 1,
              ),
            ],
          ),
        ));

    /*ListTile(
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
      ), */
  }

  Widget _buildImageHeader(String imgUrl) {
    if (imgUrl != null) {
      return Image.network(
        imgUrl,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        "assets/icons/book.png",
        scale: 0.2,
      );
    }
  }
}
