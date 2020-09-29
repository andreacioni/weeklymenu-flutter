import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';

import '../../models/recipe.dart';
import '../../providers/recipes_provider.dart';
import '../../globals/utils.dart';

class RecipeTags extends StatelessWidget {
  const RecipeTags({
    @required this.recipe,
    @required this.editEnabled,
  });

  final RecipeOriginator recipe;
  final bool editEnabled;

  List<String> _availableTags(BuildContext context) {
    List<String> recipesTags =
        Provider.of<RecipesProvider>(context, listen: false).recipeTags;
    if (recipe.tags != null) {
      recipesTags.removeWhere((tag) => recipe.tags.contains(tag));
    }

    return recipesTags;
  }

  @override
  Widget build(BuildContext context) {
    return Tags(
      itemBuilder: (index) => ItemTags(
        image: ItemTagsImage(
          child: Icon(
            Icons.local_offer,
            color: Colors.white,
          ),
        ),
        removeButton: editEnabled
            ? ItemTagsRemoveButton(onRemoved: () {
                recipe.removeTag(recipe.tags[index]);
                return true;
              })
            : null,
        title: recipe.tags[index],
        activeColor: getColorForString(recipe.tags[index]),
        combine: ItemTagsCombine.withTextAfter,
        index: index,
        pressEnabled: false,
        textScaleFactor: 1.5,
      ),
      itemCount: (recipe.tags == null) ? 0 : recipe.tags.length,
      horizontalScroll: true,
      verticalDirection: VerticalDirection.up,
      textField: editEnabled
          ? TagsTextField(
              autofocus: false,
              helperText: 'Add',
              suggestions: _availableTags(context),
              textCapitalization: TextCapitalization.words,
              maxLength: 20,
              onSubmitted: (newTag) => recipe.addTag(newTag),
              constraintSuggestion: false,
            )
          : null,
    );
  }
}
