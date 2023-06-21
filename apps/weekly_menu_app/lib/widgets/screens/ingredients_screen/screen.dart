import 'dart:developer';

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
                return Dismissible(
                  key: ValueKey(model[index].name),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (dd) => _showDismissDialog(context, dd),
                  background: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.delete,
                          size: 30,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(model[index].name),
                      ),
                      Divider(
                        height: 0,
                      ),
                    ],
                  ),
                  onDismissed: (_) => ingredients.delete(model[index]),
                );
              },
              itemCount: model.length,
            );
          }),
    );
  }

  Future<bool?> _showDismissDialog(
      BuildContext context, DismissDirection direction) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text(
            'This will also remove all related recipe ingredients and shop. list item'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('NO'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('YES'),
          ),
        ],
      ),
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
