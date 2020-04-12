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
  final List<ShoppingListItem> shopItems = <ShoppingListItem>[
    ShoppingListItem(
      item: '5e761b25189dd19a35cc0ae7',
      checked: false,
      quantity: 200,
    ),
    ShoppingListItem(
        item: '5e761b2d86315b0cfabab843', checked: true, quantity: 10)
  ];

  final FocusNode _focusNode = FocusNode();

  bool _newItemMode;

  @override
  void initState() {
    _newItemMode = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final List<ShoppingListItem> shopItems =
    //    Provider.of<ShoppingListProvider>(context).getShoppingItems;

    final checkedItems = shopItems.where((item) => item.checked).toList();
    final uncheckItems = shopItems.where((item) => !item.checked).toList();

    return CustomScrollView(
      slivers: <Widget>[
        _buildAppBar(context),
        if (shopItems.isEmpty)
          _buildNoElementsPage(),
        if (_newItemMode)
          _buildAddItem(),
        //_buildFloatingHeader('Unckecked'),
        if (shopItems.isNotEmpty)
          _buildUncheckedList(uncheckItems),
        //_buildFloatingHeader('Checked'),
        if (shopItems.isNotEmpty)
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
}
