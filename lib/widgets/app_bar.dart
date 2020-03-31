import 'package:flutter/material.dart';

class BaseAppBar extends AppBar {
  final Widget title;
  final List<Widget> actions;
  final Widget leading;

  BaseAppBar({this.title, this.actions, this.leading}) : super(centerTitle: true,
      elevation: 5.0,
      title: title,
      leading: leading,
      actions: actions);
}