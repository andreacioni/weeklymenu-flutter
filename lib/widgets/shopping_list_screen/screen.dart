import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/shopping_list_provider.dart';
import './scroll_view.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //NOTE: we get only the first list here because, by now, only one list is supported per user
    final shoppingList =
        Provider.of<ShoppingListProvider>(context).shoppingLists[0];

    return ChangeNotifierProvider.value(
      value: shoppingList,
      child: ShoppingListScrollView(),
    );
  }
}
