import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_data/flutter_data.dart';
import 'package:weekly_menu_app/widgets/flutter_data_state_builder.dart';

import '../../models/ingredient.dart';

class IngredientsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final repository = watch(ingredientsRepositoryProvider);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: FlutterDataStateBuilder<List<Ingredient>>(
          notifier: () => repository.watchAll(),
          builder: (context, state, notifier, _) {
            return ListView.builder(
              itemBuilder: (_, index) {
                return Dismissible(
                  key: ValueKey(state.model[index].id),
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
                        title: Text(state.model[index].name),
                      ),
                      Divider(
                        height: 0,
                      ),
                    ],
                  ),
                  onDismissed: (_) =>
                      _deleteIngredient(context, state.model[index]),
                );
              },
              itemCount: state.model.length,
            );
          }),
    );
  }

  Future<bool> _showDismissDialog(
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

  void _deleteIngredient(BuildContext context, Ingredient ingredient) {
    ingredient.delete();
  }
}
