import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/recipe.dart';

import '../../shared/flutter_data_state_builder.dart';

class TagsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(recipeRepositoryProvider);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: RepositoryStreamBuilder<List<Recipe>>(
        stream: repository.stream(),
        onRefresh: () async => await repository.reload(),
        builder: (context, model) {
          final tags = getAllRecipeTags(model);

          return ListView.builder(
            itemBuilder: (_, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(tags[index]),
                  ),
                  Divider(
                    height: 0,
                  ),
                ],
              );
            },
            itemCount: tags.length,
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Tags'),
    );
  }

  List<String> getAllRecipeTags(List<Recipe> recipes) {
    List<String> tags = [];
    recipes.forEach((recipe) {
      if (recipe.tags.isNotEmpty) {
        tags.addAll(recipe.tags);
      }
    });

    return tags;
  }
}
