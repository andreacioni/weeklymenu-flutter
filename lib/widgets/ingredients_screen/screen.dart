import 'package:flutter/material.dart';

import '../app_bar.dart';
class IngredientsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildAppBar(),
        Center(
          child: Text('Ingredients!'),
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return BaseAppBar(
      title: Text('Ingredients'),
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