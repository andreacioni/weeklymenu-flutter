import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../main.data.dart';
import '../flutter_data_state_builder.dart';
import '../../models/ingredient.dart';

class IngredientsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: FlutterDataStateBuilder<List<Ingredient>>(
          state: ref.ingredients.watchAll(),
          onRefresh: () => ref.ingredients.findAll(syncLocal: true),
          builder: (context, model) {
            return ListView.builder(
              itemBuilder: (_, index) {
                return Dismissible(
                  key: ValueKey(model[index].id),
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
                  onDismissed: (_) => model[index].delete(),
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
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('NO'),
          ),
          FlatButton(
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
