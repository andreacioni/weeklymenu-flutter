import 'package:flutter/material.dart';

const BOTTOM_SHEET_RADIUS = const Radius.circular(10);

class BaseModalBottomSheet extends StatelessWidget {
  final Widget child;

  const BaseModalBottomSheet({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
    );
  }
}
