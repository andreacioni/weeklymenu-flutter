import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/shopping_list.dart';
import 'package:data/main.data.dart';

final shoppingListProvider = Provider<ShoppingList?>((ref) {
  final shopList = ref.flutterDataShoppingLists.watchAll();
  return shopList.hasModel && (shopList.model?.isNotEmpty ?? false)
      ? shopList.model![0]
      : null;
});

final shoppingListItemsProvider = Provider<List<ShoppingListItem>?>((ref) {
  return ref.watch(shoppingListProvider)?.items;
});
