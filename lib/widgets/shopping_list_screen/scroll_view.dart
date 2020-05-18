import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/models/ingredient.dart';
import 'package:weekly_menu_app/providers/ingredients_provider.dart';

import './shopping_list_tile.dart';
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
      floatingActionButton: _newItemMode
          ? null
          : FloatingActionButton(
              onPressed: _newItemMode == false
                  ? () => setState(() {
                        _newItemMode = true;
                      })
                  : null,
              child: Icon(Icons.add),
            ),
      body: CustomScrollView(
        slivers: <Widget>[
          _buildAppBar(context),
          //if (allItems.isEmpty)
          //  _buildNoElementsPage(),
          if (_loading)
            _buildLoadingItem(),
          if (_newItemMode)
            _buildAddItem(shoppingList),
          //_buildFloatingHeader('Unckecked'),
          if (allItems.isNotEmpty)
            ..._buildUncheckedList(shoppingList),
          //_buildFloatingHeader('Checked'),
          if (allItems.isNotEmpty)
            ..._buildCheckedList(shoppingList),
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
              onShoppingItemSelected: (shopItem) => shoppingList.setChecked(
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
            (_, index) => ShoppingListItemTile(
              checkItems[index],
              editable: false,
              key: ValueKey(checkItems[index].item),
              onCheckChange: (newValue) => shoppingList.setChecked(
                checkItems[index],
                newValue,
              ),
              onDismiss: (_) =>
                  shoppingList.removeItemFromList(checkItems[index]),
            ),
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
                  key: ValueKey(uncheckItems[index].item),
                  editable: false,
                  onCheckChange: (newValue) => shoppingList.setChecked(
                    uncheckItems[index],
                    newValue,
                  ),
                  onDismiss: (_) => shoppingList.removeItemFromList(
                    uncheckItems[index],
                  ),
                ),
            childCount: uncheckItems.length),
      ),
    ];
  }

  Widget _buildNoElementsPage() {
    final _textColor = Colors.grey.shade300;
    return Flex(
      direction: Axis.vertical,
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
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      elevation: 5,
      forceElevated: true,
      pinned: true,
      title: Text('Shopping List'),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 30.0,
          color: Colors.black,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    );
  }

  void _createShopItemForIngredient(ShoppingList shoppingList, Ingredient ing) {
    shoppingList
        .addShoppingListItem(ShoppingListItem(item: ing.id, checked: false));
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
}
