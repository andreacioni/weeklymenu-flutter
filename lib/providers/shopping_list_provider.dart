import 'package:flutter/material.dart';

import '../datasource/network.dart';
import '../models/shopping_list.dart';

class ShoppingListProvider with ChangeNotifier {
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();

  List<ShoppingList> _shoppingList;


  Future<void> fetchShoppingListItems() async {
    //TODO handle pagination
    final jsonPage = await _restApi.getShoppingList();
    _shoppingList = jsonPage['results']
        .map((jsonMenu) => ShoppingList.fromJson(jsonMenu))
        .toList()
        .cast<ShoppingList>();

    notifyListeners();
  }

  List<ShoppingList> get getShoppingLists => [..._shoppingList]; 
}
