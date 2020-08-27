import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/models/ingredient.dart';
import 'package:weekly_menu_app/providers/ingredients_provider.dart';
import 'package:weekly_menu_app/providers/shopping_list_provider.dart';

import './shopping_list_tile.dart';
import '../../globals/errors_handlers.dart';
import '../../models/shopping_list.dart';
import './item_suggestion_text_field.dart';

class ShoppingListScrollView extends StatefulWidget {
  @override
  _ShoppingListScrollViewState createState() => _ShoppingListScrollViewState();
}

class _ShoppingListScrollViewState extends State<ShoppingListScrollView> {
  bool _newItemMode;
  bool _expandChecked;
  bool _loading;

  @override
  void initState() {
    _expandChecked = true;
    _newItemMode = false;
    _loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shoppingList = Provider.of<ShoppingList>(context);

    final allItems = shoppingList.getAllItems;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: allItems.isEmpty && !_newItemMode
          ? _buildNoElementsPage()
          : CustomScrollView(
              slivers: <Widget>[
                //if (allItems.isEmpty) _buildNoElementsPage(),
                if (_loading) _buildLoadingItem(),
                if (_newItemMode) _buildAddItem(shoppingList),
                //_buildFloatingHeader('Unckecked'),
                if (allItems.isNotEmpty) ..._buildUncheckedList(shoppingList),
                //_buildFloatingHeader('Checked'),
                if (allItems.isNotEmpty) ..._buildCheckedList(shoppingList),
              ],
            ),
    );
  }

  Widget _buildLoadingItem() {
    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        <Widget>[
          ListTile(
            title: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Divider(
            height: 0,
          )
        ],
      ),
    );
  }

  Widget _buildAddItem(ShoppingList shoppingList) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        <Widget>[
          ListTile(
            leading: Icon(Icons.add),
            title: ItemSuggestionTextField(
              hintText: 'Add element...',
              autofocus: true,
              onFocusChanged: (hasFocus) {
                if (hasFocus == false) {
                  setState(() {
                    _newItemMode = false;
                  });
                }
              },
              onSubmitted: (ingredientName) =>
                  _createNewIngredientAndShopItem(shoppingList, ingredientName),
              onShoppingItemSelected: (shopItem) => _setChecked(
                shoppingList,
                shopItem,
                false,
              ),
              onIngredientSelected: (ingredient) =>
                  _createShopItemForIngredient(shoppingList, ingredient),
            ),
          ),
          Divider(
            height: 0,
          )
        ],
      ),
    );
  }

  List<Widget> _buildCheckedList(ShoppingList shoppingList) {
    final checkItems = shoppingList.getCheckedItems;
    return [
      SliverAppBar(
        primary: false,
        pinned: true,
        title: Text("Checked (${checkItems.length})"),
        forceElevated: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade100,
        actions: <Widget>[
          if (_expandChecked)
            IconButton(
              icon: Icon(Icons.expand_less),
              onPressed: () => setState(() => _expandChecked = false),
            ),
          if (!_expandChecked)
            IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () => setState(() => _expandChecked = true),
            )
        ],
      ),
      if (_expandChecked)
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => ShoppingListItemTile(checkItems[index],
                editable: false,
                formKey: ValueKey(checkItems[index].item),
                onCheckChange: (newValue) => _setChecked(
                      shoppingList,
                      checkItems[index],
                      newValue,
                    ),
                onDismiss: (_) =>
                    _removeItemFromList(shoppingList, checkItems[index])),
            childCount: checkItems.length,
          ),
        )
    ];
  }

  List<Widget> _buildUncheckedList(ShoppingList shoppingList) {
    final uncheckItems = shoppingList.getUncheckedItems;
    return [
      SliverList(
        delegate: SliverChildBuilderDelegate(
            (_, index) => ShoppingListItemTile(
                  uncheckItems[index],
                  formKey: ValueKey(uncheckItems[index].item),
                  editable: false,
                  onCheckChange: (newValue) => _setChecked(
                    shoppingList,
                    uncheckItems[index],
                    newValue,
                  ),
                  onDismiss: (_) => _removeItemFromList(
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 5,
      title: Text('Shopping List'),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 30.0,
          color: Colors.black,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: _newItemMode == false
              ? () => setState(() => _newItemMode = true)
              : null,
        )
      ],
    );
  }

  Future<void> _createShopItemForIngredient(
      ShoppingList shoppingList, Ingredient ing) async {
    ShoppingListItem item = ShoppingListItem(item: ing.id, checked: false);

    shoppingList.addShoppingListItem(item);

    try {
      await Provider.of<ShoppingListProvider>(context, listen: false)
          .updateShoppingList(shoppingList);
    } catch (e) {
      showAlertErrorMessage(context);
      shoppingList.removeItemFromList(item);
    }
  }

  void _createNewIngredientAndShopItem(
      ShoppingList shoppingList, String ingredientName) async {
    IngredientsProvider ingredientsProvider =
        Provider.of<IngredientsProvider>(context, listen: false);
    setState(() => _loading = true);
    Ingredient newIngredient = await ingredientsProvider
        .addIngredient(Ingredient(name: ingredientName));
    setState(() => _loading = false);
    _createShopItemForIngredient(shoppingList, newIngredient);
  }

  Future<void> _removeItemFromList(
      ShoppingList shoppingList, ShoppingListItem shoppingListItem) async {
    shoppingList.removeItemFromList(shoppingListItem);
    try {
      await Provider.of<ShoppingListProvider>(context, listen: false)
          .updateShoppingList(shoppingList);
    } catch (e) {
      showAlertErrorMessage(context);
      shoppingList.addShoppingListItem(shoppingListItem);
    }
  }

  Future<void> _setChecked(ShoppingList shoppingList, ShoppingListItem shopItem,
      bool checked) async {
    shoppingList.setChecked(
      shopItem,
      checked,
    );

    try {
      await Provider.of<ShoppingListProvider>(context, listen: false)
          .updateShoppingList(shoppingList);
    } catch (e) {
      showAlertErrorMessage(context);
      shoppingList.setChecked(
        shopItem,
        !checked,
      );
    }
  }
}
