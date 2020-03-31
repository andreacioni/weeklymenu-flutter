import 'package:flutter/material.dart';

class BaseAppBar extends AppBar {
  final Widget title;
  final List<Widget> actions;

  BaseAppBar({this.title, this.actions}) : super(centerTitle: true,
      elevation: 5.0,
      title: title,
      leading: const IconButton(
        icon: Icon(
          Icons.menu,
          size: 30.0,
          color: Colors.black,
        ),
        onPressed: null,
      ),
      actions: actions);
}