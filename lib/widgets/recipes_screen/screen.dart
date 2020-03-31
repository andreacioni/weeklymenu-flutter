import 'package:flutter/material.dart';

import '../app_bar.dart';
class RecipesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildAppBar(),
        Center(
          child: Text('Recipes!'),
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return BaseAppBar(
      title: Text('Recipes'),
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