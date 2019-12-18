import 'package:flutter/material.dart';

class WMAppBar extends AppBar {
  static const _title = const Text(
    'Weekly Menu',
    style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'Arial'),
  );

  WMAppBar()
      : super(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: FlatButton(
            child: _title,
            onPressed: () => {},
          ),
          leading: const IconButton(
            icon: Icon(
              Icons.more_horiz,
              size: 30.0,
              color: Colors.black,
            ),
            onPressed: null,
          ),
          actions: const <Widget>[
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                size: 30.0,
                color: Colors.black,
              ),
              onPressed: null,
            ),
          ],
        );
}
