import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:weekly_menu_app/models/shopping_list.dart';
import '../models/user_preferences.dart';
import '../main.data.dart';

final shoppingListProvider = Provider<ShoppingList?>((ref) {
  final shopList = ref.shoppingLists.watchAll();
  return shopList.hasModel && (shopList.model?.isNotEmpty ?? false)
      ? shopList.model![0]
      : null;
});

final shoppingListItemsProvider = Provider<List<ShoppingListItem>?>((ref) {
  return ref.watch(shoppingListProvider)?.items;
});
