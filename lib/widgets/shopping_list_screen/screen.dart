import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:objectid/objectid.dart';

import '../flutter_data_state_builder.dart';
import '../../models/ingredient.dart';
import './shopping_list_tile.dart';
import '../../globals/errors_handlers.dart';
import '../../models/shopping_list.dart';
import './item_suggestion_text_field.dart';

class ShoppingListScreen extends StatefulWidget {
  ShoppingListScreen({Key? key}) : super(key: key);

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  late final bool _newItemMode;
  late final bool _expandChecked;
  late final bool _loading;

  @override
  void initState() {
    _expandChecked = true;
    _newItemMode = false;
    _loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final repository = ref.watch(shoppingListsRepositoryProvider);
      return Scaffold(
        appBar: _buildAppBar(context),
        body: FlutterDataStateBuilder<List<ShoppingList>>(
          notifier: () => repository.watchAll(),
          builder: (context, state, notifier, _) {
            //Get only the first element, by now only one list per user is supported
            final shoppingList = notifier.data.model[0];
            final allItems = shoppingList.getAllItems;

            return allItems.isEmpty && !_newItemMode
                ? _buildNoElementsPage()
                : CustomScrollView(
                    slivers: <Widget>[
                      //if (allItems.isEmpty) _buildNoElementsPage(),
                      if (_loading) _buildLoadingItem(),
                      if (_newItemMode) _buildAddItem(ref, shoppingList),
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
    });
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
                  setState(() {
                    _newItemMode = false;
                  });
                }
              },
              onSubmitted: (ingredientName) => _createNewIngredientAndShopItem(
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

  List<Widget> _buildCheckedList(WidgetRef ref, ShoppingList shoppingList) {
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
                      ref,
                      shoppingList,
                      checkItems[index],
                      newValue,
                    ),
                onDismiss: (_) =>
                    _removeItemFromList(ref, shoppingList, checkItems[index])),
            childCount: checkItems.length,
          ),
        )
    ];
  }

  List<Widget> _buildUncheckedList(WidgetRef ref, ShoppingList shoppingList) {
    final uncheckItems = shoppingList.getUncheckedItems;
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 5,
      title: Row(
        children: [
          const Text('Shopping List'),
        ],
      ),
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
      WidgetRef ref, ShoppingList shoppingList, Ingredient ing) async {
    ShoppingListItem item = ShoppingListItem(item: ing.id, checked: false);

    shoppingList.addShoppingListItem(item);

    try {
      await ref.read(shoppingListsRepositoryProvider).save(shoppingList);
    } catch (e) {
      showAlertErrorMessage(context);
      shoppingList.removeItemFromList(item);
    }
  }

  void _createNewIngredientAndShopItem(
      WidgetRef ref, ShoppingList shoppingList, String ingredientName) async {
    Repository<Ingredient> ingredientsRepo =
        ref.read(ingredientsRepositoryProvider);
    setState(() => _loading = true);
    Ingredient newIngredient = await ingredientsRepo
        .save(Ingredient(id: ObjectId().hexString, name: ingredientName));
    setState(() => _loading = false);
    _createShopItemForIngredient(ref, shoppingList, newIngredient);
  }

  Future<void> _removeItemFromList(WidgetRef ref, ShoppingList shoppingList,
      ShoppingListItem shoppingListItem) async {
    shoppingList.removeItemFromList(shoppingListItem);
    try {
      await ref.read(shoppingListsRepositoryProvider).save(shoppingList);
    } catch (e) {
      showAlertErrorMessage(context);
      shoppingList.addShoppingListItem(shoppingListItem);
    }
  }

  Future<void> _setChecked(WidgetRef ref, ShoppingList shoppingList,
      ShoppingListItem shopItem, bool checked) async {
    shoppingList.setChecked(
      shopItem,
      checked,
    );

    try {
      await ref.read(shoppingListsRepositoryProvider).save(shoppingList);
    } catch (e) {
      showAlertErrorMessage(context);
      shoppingList.setChecked(
        shopItem,
        !checked,
      );
    }
  }
}
