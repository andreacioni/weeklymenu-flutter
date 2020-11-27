import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_data_state/flutter_data_state.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/widgets/flutter_data_state_builder.dart';

import '../../models/recipe.dart';

class TagsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Repository<Recipe> repository = context.watch<Repository<Recipe>>();
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
