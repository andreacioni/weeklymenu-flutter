import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart'
    hide Provider, DataStateNotifier;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/widgets/flutter_data_state_builder.dart';

import '../../models/recipe.dart';

class TagsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Repository<Recipe> repository = ref.watch(recipesRepositoryProvider);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: FlutterDataStateBuilder<List<Recipe>>(
        notifier: () => repository.watchAll(),
        builder: (_, state, notifier, __) {
          final tags = getAllRecipeTags(state.model);

          return RefreshIndicator(
            onRefresh: () async => notifier.reload(),
            child: ListView.builder(
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
            ),
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
      if (recipe.tags != null) {
        tags.addAll(recipe.tags);
      }
    });

    return tags;
  }
}
