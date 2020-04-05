import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/ingredients_provider.dart';
import '../../models/shopping_list.dart';
import '../../models/ingredient.dart';

class ShoppingListItemTile extends StatefulWidget {
  ShoppingListItem shoppingListItem;

  ShoppingListItemTile(this.shoppingListItem);

  @override
  _ShoppingListItemTileState createState() => _ShoppingListItemTileState();
}

class _ShoppingListItemTileState extends State<ShoppingListItemTile> {
  @override
  Widget build(BuildContext context) {
    final Ingredient ingredient = Provider.of<IngredientsProvider>(context).getById(widget.shoppingListItem.item);
    return ListTile(
      title: Text(ingredient.name),
    );
  }
}