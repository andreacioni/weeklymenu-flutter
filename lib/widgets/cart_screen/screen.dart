import 'package:flutter/material.dart';

import '../app_bar.dart';
class CartScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildAppBar(context),
        Center(
          child: Text('Cart!'),
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