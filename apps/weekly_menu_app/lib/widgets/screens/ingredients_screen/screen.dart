import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/ingredient.dart';

import '../../shared/flutter_data_state_builder.dart';

class IngredientsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredients = ref.watch(ingredientsRepositoryProvider);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: RepositoryStreamBuilder<List<Ingredient>>(
          stream: ingredients.stream(),
          onRefresh: () async => await ingredients.reload(),
          builder: (context, model) {
            return ListView.builder(
              itemBuilder: (_, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(model[index].name),
                    ),
                    Divider(
                      height: 0,
                    ),
                  ],
                );
              },
              itemCount: model.length,
            );
          }),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          const Text('Ingredients'),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {},
        )
      ],
    );
  }
}
