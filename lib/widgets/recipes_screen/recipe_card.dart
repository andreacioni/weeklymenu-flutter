import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekly_menu_app/widgets/flutter_data_state_builder.dart';

import '../../models/recipe.dart';

class RecipeCard extends ConsumerWidget {
  final String recipeId;
  final Function onLongPress;
  final Function onTap;
  final BorderSide borderSide;
  final Color shadowColorStart;
  final Color shadowColorEnd;

  RecipeCard(this.recipeId,
      {this.onLongPress,
      this.onTap,
      this.borderSide = BorderSide.none,
      this.shadowColorStart,
      this.shadowColorEnd = Colors.transparent});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final borderRadius = BorderRadius.circular(10);
    final recipesRepository = watch(recipesRepositoryProvider);
    return FlutterDataStateBuilder(
      notifier: () => recipesRepository.watchOne(recipeId),
      builder: (context, data, _, __) {
        final recipe = data.model;
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
      },
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
