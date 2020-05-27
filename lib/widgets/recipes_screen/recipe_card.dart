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
    final borderRadius = BorderRadius.circular(10);
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: borderSide,
      ),
      color: color,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          //color: Theme.of(context).primaryColor.withOpacity(0.4),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: _buildImageProvider(_recipe.imgUrl),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black54, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              color: Colors.blueAccent,
              borderRadius: borderRadius,
            ),
            alignment: AlignmentDirectional.bottomStart,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _recipe.name,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white.withOpacity(0.88),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
          ),
        ),
      ),
    );

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
    Widget imgWidget;
    if (imgUrl != null) {
      imgWidget = Image.network(
        imgUrl,
      );
    } else {
      imgWidget = Image.asset(
        "assets/icons/book.png",
        scale: 0.2,
      );
    }

    return FittedBox(
      child: imgWidget,
      fit: BoxFit.cover,
    );
  }

  DecorationImage _buildImageProvider(String imgUrl) {
    if (imgUrl != null) {
      return DecorationImage(
        image: NetworkImage(
          imgUrl,
        ),
        fit: BoxFit.cover,
      );
    } else {
      return DecorationImage(
        image: AssetImage(
          "assets/icons/book.png",
        ),
        fit: BoxFit.scaleDown,
      );
    }
  }
}
