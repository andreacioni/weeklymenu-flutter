import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/recipe.dart';
import '../../globals/utils.dart';

class RecipeTags extends HookConsumerWidget {
  final RecipeOriginator recipe;
  final bool editEnabled;

  const RecipeTags({
    required this.recipe,
    required this.editEnabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Repository<Recipe> recipeRepo = ref.read(recipesRepositoryProvider);

    return FutureBuilder<List<Recipe>>(
      future: recipeRepo.findAll(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error occurred");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return buildTagsRow(snapshot.data ?? <Recipe>[]);
      },
    );
  }

  Widget buildTagsRow(List<Recipe> recipes) {
    final tags = getAllRecipeTags(recipes);

    tags.removeWhere((tag) => recipe.instance.tags.contains(tag));

    return Container();

    /* return Tags(
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
              suggestions: tags,
              textCapitalization: TextCapitalization.words,
              maxLength: 20,
              onSubmitted: (newTag) => recipe.addTag(newTag),
              constraintSuggestion: false,
            )
          : null,
    ); */
  }

  List<String> getAllRecipeTags(List<Recipe> recipes) {
    List<String> tags = [];
    recipes.forEach((recipe) {
      if (recipe.tags != null) {
        tags.addAll(recipe.tags);
      }
    });

    return tags;
  }
}
