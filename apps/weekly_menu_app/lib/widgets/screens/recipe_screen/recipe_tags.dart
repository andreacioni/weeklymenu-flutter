import 'package:common/utils.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/recipe.dart';

class RecipeTags extends HookConsumerWidget {
  final RecipeOriginator recipe;
  final bool editEnabled;

  const RecipeTags({
    required this.recipe,
    required this.editEnabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Repository<Recipe> recipeRepo = ref.read(recipeRepositoryProvider);

    return FutureBuilder<List<Recipe>>(
      future: (() async => await recipeRepo.loadAll())(),
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
                final newList = recipe.instance.tags..removeAt(index);
                recipe.update(recipe.instance.copyWith(tags: newList));
                return true;
              })
            : null,
        title: recipe.instance.tags[index],
        activeColor: getColorForString(recipe.instance.tags[index]),
        combine: ItemTagsCombine.withTextAfter,
        index: index,
        pressEnabled: false,
        textScaleFactor: 1.5,
      ),
      itemCount: recipe.instance.tags.length,
      horizontalScroll: true,
      verticalDirection: VerticalDirection.up,
      textField: editEnabled
          ? TagsTextField(
              autofocus: false,
              helperText: 'Add',
              suggestions: tags,
              textCapitalization: TextCapitalization.words,
              maxLength: 20,
              onSubmitted: (newTag) => recipe.update(recipe.instance
                  .copyWith(tags: [...recipe.instance.tags, newTag])),
              constraintSuggestion: false,
            )
          : null,
    );
  }

  List<String> getAllRecipeTags(List<Recipe> recipes) {
    List<String> tags = [];
    recipes.forEach((recipe) {
      tags.addAll(recipe.tags);
    });

    return tags;
  }
}
