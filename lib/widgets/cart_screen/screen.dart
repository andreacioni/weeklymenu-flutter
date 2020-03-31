import 'package:flutter/material.dart';

import '../app_bar.dart';
class CartScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildAppBar(),
        Center(
          child: Text('Cart!'),
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return BaseAppBar(
      title: Text('Cart'),
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