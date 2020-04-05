import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/custom_icons_icons.dart';
import './shopping_list_tile.dart';
import '../../models/shopping_list.dart';
import '../../providers/shopping_list_provider.dart';
import '../app_bar.dart';

class ShoppingListScreen extends StatefulWidget {

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {

  bool _insertNewElementMode = false;

  @override
  Widget build(BuildContext context) {
    
    final List<ShoppingListItem> shopItems = Provider.of<ShoppingListProvider>(context).getShoppingItems;
    ShoppingListItem newItem;

    if(_insertNewElementMode){
      //Creating a placeholder for the new item
      newItem = ShoppingListItem();
    }
    
    return Column(
      children: <Widget>[
        _buildAppBar(context),
        if(shopItems.isEmpty)
        _buildNoElementsPage(),
        if(shopItems.isNotEmpty && !_insertNewElementMode)
        _buildShoppingListItemList(shopItems),
        if(shopItems.isNotEmpty && _insertNewElementMode)
        _buildShoppingListItemList([newItem, ...shopItems]),
      ],
    );
  }

  Widget _buildShoppingListItemList(List<ShoppingListItem> items) {
    return ListView.builder(itemBuilder: (_, index) => ShoppingListItemTile(items[index]), itemCount: items.length);
  }

  Widget _buildNoElementsPage() {
    final _textColor = Colors.grey.shade300;
    return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
            )
          ],
        ),
      );
  }

  AppBar _buildAppBar(BuildContext context) {
    return BaseAppBar(
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
}
