import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/custom_icons_icons.dart';
import './shopping_list_tile.dart';
import '../../models/shopping_list.dart';
import '../../providers/shopping_list_provider.dart';
import '../app_bar.dart';
import './item_suggestion_text_field.dart';

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final FocusNode _focusNode = FocusNode();

  bool _newItemMode;

  @override
  void initState() {
    _newItemMode = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);

    final allItems = shoppingListProvider.getCartItems;
    final checkedItems = shoppingListProvider.getCheckedItems;
    final uncheckItems = shoppingListProvider.getUncheckedItems;

    return CustomScrollView(
      slivers: <Widget>[
        _buildAppBar(context),
        //if (allItems.isEmpty)
        //  _buildNoElementsPage(),
        if (_newItemMode)
          _buildAddItem(),
        //_buildFloatingHeader('Unckecked'),
        if (allItems.isNotEmpty)
          _buildUncheckedList(uncheckItems),
        //_buildFloatingHeader('Checked'),
        if (allItems.isNotEmpty)
          _buildCheckedList(checkedItems),
      ],
    );
  }

  Widget _buildAddItem() {
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
              onShoppingItemSelected: (shopItem) {
                setState(() {
                  shopItem.checked = false;
                });
              },
            ),
          ),
          Divider()
        ],
      ),
    );
  }

  Widget _buildCheckedList(List<ShoppingListItem> items) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) => ShoppingListItemTile(
          items[index],
          key: ValueKey(items[index].item),
          onCheckChange: (newValue) =>
              setState(() => items[index].checked = newValue),
          onDismiss: (_) => _deleteElementFromList(items[index]),
        ),
        childCount: items.length,
      ),
    );
  }

  Widget _buildUncheckedList(List<ShoppingListItem> items) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (_, index) => ShoppingListItemTile(
                items[index],
                key: ValueKey(items[index].item),
                onCheckChange: (newValue) =>
                    setState(() => items[index].checked = newValue),
                onDismiss: (_) => _deleteElementFromList(items[index]),
              ),
          childCount: items.length),
    );
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
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: _newItemMode == false
              ? () => setState(() {
                    _newItemMode = true;
                  })
              : null,
        )
      ],
    );
  }

  void _deleteElementFromList(ShoppingListItem item) {}
}
