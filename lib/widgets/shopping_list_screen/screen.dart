import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:objectid/objectid.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weekly_menu_app/widgets/shopping_list_screen/shopping_list_app_bar.dart';

import '../flutter_data_state_builder.dart';
import '../../models/ingredient.dart';
import './shopping_list_tile.dart';
import '../../globals/errors_handlers.dart';
import '../../models/shopping_list.dart';
import './item_suggestion_text_field.dart';
import 'package:weekly_menu_app/main.data.dart';

final selectedShoppingListItems =
    StateProvider.autoDispose(((_) => <String>[]));

Color getColorByString(String s) {
  const colorList = [
    Colors.amber,
    Colors.blue,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.indigo,
    Colors.lime,
  ];

  return colorList[s.hashCode % colorList.length];
}

final supermarketSectionList = Provider.autoDispose(((ref) {
  final shoppingListItems = ref.shoppingLists.watchAll().model[0].items;
  return (shoppingListItems
        ..removeWhere((e) => e.supermarketSection?.isEmpty ?? false))
      .map((e) => e.supermarketSection)
      .toSet()
      .toList();
}));

class ShoppingListScreen extends HookConsumerWidget {
  ShoppingListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newItemMode = useState(false);
    final expandChecked = useState(true);

    Widget _buildLoadingItem() {
      return SliverList(
        delegate: SliverChildListDelegate.fixed(
          <Widget>[
            ListTile(
              title: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Divider(height: 0)
          ],
        ),
      );
    }

    Future<void> _createShopItemForIngredient(
        WidgetRef ref, ShoppingList shoppingList, Ingredient ing) async {
      ShoppingListItem item = ShoppingListItem(item: ing.id, checked: false);

      shoppingList.addShoppingListItem(item);

      try {
        await ref.shoppingLists.save(shoppingList, params: {'update': true});
      } catch (e) {
        showAlertErrorMessage(context);
        shoppingList.removeItemFromList(item);
      }
    }

    void _createNewIngredientAndShopItem(
        WidgetRef ref, ShoppingList shoppingList, String ingredientName) async {
      Repository<Ingredient> ingredientsRepo =
          ref.read(ingredientsRepositoryProvider);

      Ingredient newIngredient =
          Ingredient(id: ObjectId().hexString, name: ingredientName);
      ingredientsRepo.save(newIngredient, params: {'update': false});

      _createShopItemForIngredient(ref, shoppingList, newIngredient);
    }

    Future<void> _setChecked(WidgetRef ref, ShoppingList shoppingList,
        ShoppingListItem shopItem, bool checked) async {
      try {
        await shoppingList
            .setChecked(shopItem, checked)
            .save(params: {'update': true});
      } catch (e) {
        showAlertErrorMessage(context);
        shoppingList.setChecked(
          shopItem,
          !checked,
        );
      }
    }

    Widget _buildAddItem(WidgetRef ref, ShoppingList shoppingList) {
      return SliverList(
        delegate: SliverChildListDelegate.fixed(
          <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: ItemSuggestionTextField(
                hintText: 'Add element...',
                autoFocus: true,
                onFocusChanged: (hasFocus) {
                  if (hasFocus == false) {
                    newItemMode.value = false;
                  }
                },
                onSubmitted: (ingredientName) =>
                    _createNewIngredientAndShopItem(
                        ref, shoppingList, ingredientName),
                onShoppingItemSelected: (shopItem) => _setChecked(
                  ref,
                  shoppingList,
                  shopItem,
                  false,
                ),
                onIngredientSelected: (ingredient) =>
                    _createShopItemForIngredient(ref, shoppingList, ingredient),
              ),
            ),
            Divider(
              height: 0,
            )
          ],
        ),
      );
    }

    Future<void> _removeItemFromList(WidgetRef ref, ShoppingList shoppingList,
        ShoppingListItem shoppingListItem) async {
      shoppingList.removeItemFromList(shoppingListItem);
      try {
        await ref
            .read(shoppingListsRepositoryProvider)
            .save(shoppingList, params: {'update': true});
      } catch (e) {
        showAlertErrorMessage(context);
        shoppingList.addShoppingListItem(shoppingListItem);
      }
    }

    List<Widget> _buildCheckedList(WidgetRef ref, ShoppingList shoppingList) {
      final checkItems = shoppingList.getCheckedItems
        ..sort((a, b) =>
            (a.supermarketSection ?? '').compareTo(b.supermarketSection ?? ''));

      return [
        SliverAppBar(
          primary: false,
          pinned: true,
          title: Text("Checked (${checkItems.length})"),
          forceElevated: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey.shade100,
          centerTitle: false,
          actions: <Widget>[
            if (expandChecked.value)
              IconButton(
                icon: Icon(Icons.expand_less),
                onPressed: () => expandChecked.value = false,
              ),
            if (!expandChecked.value)
              IconButton(
                icon: Icon(Icons.expand_more),
                onPressed: () => expandChecked.value = true,
              )
          ],
        ),
        if (expandChecked.value)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) => ShoppingListItemTile(checkItems[index],
                  editable: false,
                  formKey: ValueKey(checkItems[index].item),
                  onCheckChange: (newValue) => _setChecked(
                        ref,
                        shoppingList,
                        checkItems[index],
                        newValue,
                      ),
                  onDismiss: (_) => _removeItemFromList(
                      ref, shoppingList, checkItems[index])),
              childCount: checkItems.length,
            ),
          )
      ];
    }

    List<Widget> _buildUncheckedList(WidgetRef ref, ShoppingList shoppingList) {
      final uncheckItems = shoppingList.getUncheckedItems
        ..sort((a, b) =>
            (a.supermarketSection ?? '').compareTo(b.supermarketSection ?? ''));
      return [
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (_, index) => ShoppingListItemTile(
                    uncheckItems[index],
                    formKey: ValueKey(uncheckItems[index].item),
                    editable: false,
                    onCheckChange: (newValue) => _setChecked(
                      ref,
                      shoppingList,
                      uncheckItems[index],
                      newValue,
                    ),
                    onDismiss: (_) => _removeItemFromList(
                      ref,
                      shoppingList,
                      uncheckItems[index],
                    ),
                  ),
              childCount: uncheckItems.length),
        ),
      ];
    }

    Widget _buildNoElementsPage() {
      final _textColor = Colors.grey.shade300;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_box,
              size: 150,
              color: _textColor,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Your Shopping List Is Empty',
              style: TextStyle(
                fontSize: 25,
                color: _textColor,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: const ShoppingListAppBar(),
      floatingActionButton: newItemMode.value == false
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => newItemMode.value = true,
            )
          : null,
      body: FlutterDataStateBuilder<List<ShoppingList>>(
        state: ref.shoppingLists.watchAll(syncLocal: true),
        onRefresh: () => ref.shoppingLists.findAll(syncLocal: true),
        //notFound: _buildNoElementsPage(),
        builder: (context, data) {
          if (data.isEmpty) {
            return _buildNoElementsPage();
          }
          //Get only the first element, by now only one list per user is supported
          final shoppingList = data[0];
          final allItems = shoppingList.getAllItems;

          return allItems.isEmpty && !newItemMode.value
              ? _buildNoElementsPage()
              : CustomScrollView(
                  slivers: <Widget>[
                    //if (allItems.isEmpty) _buildNoElementsPage(),
                    if (newItemMode.value) _buildAddItem(ref, shoppingList),
                    //_buildFloatingHeader('Unckecked'),
                    if (allItems.isNotEmpty)
                      ..._buildUncheckedList(ref, shoppingList),
                    //_buildFloatingHeader('Checked'),
                    if (allItems.isNotEmpty)
                      ..._buildCheckedList(ref, shoppingList),
                  ],
                );
        },
      ),
    );
  }
}
