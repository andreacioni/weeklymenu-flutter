import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Function onLongPress;
  final Function onTap;
  final BorderSide borderSide;
  final Color shadowColorStart;
  final Color shadowColorEnd;

  RecipeCard(
      {this.onLongPress,
      this.onTap,
      this.borderSide = BorderSide.none,
      this.shadowColorStart,
      this.shadowColorEnd = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);
    final recipe = Provider.of<Recipe>(context);
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: borderSide,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          //color: Theme.of(context).primaryColor.withOpacity(0.4),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: _buildImageProvider(recipe.imgUrl),
          ),
          child: Material(
            //Workaround to place the InkWell animation over the recipe image (https://github.com/flutter/flutter/issues/3782)
            color: Colors.transparent,
            child: InkWell(
              borderRadius: borderRadius,
              splashColor: Theme.of(context).primaryColor.withOpacity(0.5),
              onTap: onTap,
              onLongPress: onLongPress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [shadowColorStart, shadowColorEnd],
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
                    recipe.name,
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
        ),
      ),
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
