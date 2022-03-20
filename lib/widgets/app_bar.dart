import 'package:flutter/material.dart';

@Deprecated("Use AppBar insted")
class BaseAppBar extends AppBar {
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool automaticallyImplyLeading;

  BaseAppBar(
      {required this.title,
      required this.actions,
      required this.leading,
      this.automaticallyImplyLeading = true})
      : super(
          centerTitle: true,
          elevation: 5.0,
          titleSpacing: 0,
          title: title,
          leading: leading,
          actions: actions,
          automaticallyImplyLeading: automaticallyImplyLeading,
        );
}
