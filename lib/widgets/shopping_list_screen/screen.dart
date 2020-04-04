import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/custom_icons_icons.dart';
import '../../models/shopping_list_item.dart';
import '../../providers/shopping_list_provider.dart';
import '../app_bar.dart';

class CartScreen extends StatefulWidget {

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    
    final List<ShoppingListItem> shopItems = Provider.of<ShoppingListProvider>(context).getShoppingItems;
    return Column(
      children: <Widget>[
        _buildAppBar(context),
        if(shopItems.isEmpty)
        _buildNoElementsPage(),
      ],
    );
  }

  Expanded _buildNoElementsPage() {
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
      actions: const <Widget>[],
    );
  }
}
