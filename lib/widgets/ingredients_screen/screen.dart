import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/ingredient.dart';
import '../../providers/ingredients_provider.dart';
import '../app_bar.dart';

class IngredientsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Ingredient> ingredients =
        Provider.of<IngredientsProvider>(context).getIngredients;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView.builder(
        itemBuilder: (bCtx, index) {
          return Dismissible(
            key: ValueKey(ingredients[index].id),
            direction: DismissDirection.endToStart,
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
                  title: Text(ingredients[index].name),
                ),
                Divider(),
              ],
            ),
            onDismissed: (_) => _deleteIngredient(context, ingredients[index]),
          );
        },
        itemCount: ingredients.length,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Ingredients'),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.add), onPressed: () {} ,)
      ],
    );
  }

  void _deleteIngredient(BuildContext context, Ingredient ingredient) {
    Provider.of<IngredientsProvider>(context, listen: false)
        .deleteIngredient(ingredient);
  }
}
