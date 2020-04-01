import 'package:flutter/material.dart';

import '../../presentation/custom_icons_icons.dart';
import '../app_bar.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _textColor = Colors.grey.shade300;
    return Column(
      children: <Widget>[
        _buildAppBar(context),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                CustomIcons.shopping_cart_with_check,
                size: 150,
                color: _textColor,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Your Cart Is Empty',
                style: TextStyle(
                  fontSize: 25,
                  color: _textColor,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return BaseAppBar(
      title: Text('Cart'),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 30.0,
          color: Colors.black,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: const <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            size: 30.0,
            color: Colors.black,
          ),
          onPressed: null,
        ),
      ],
    );
  }
}
