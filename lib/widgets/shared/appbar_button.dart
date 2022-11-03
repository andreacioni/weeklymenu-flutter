import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AppBarButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;
  const AppBarButton({Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.9),
          foregroundColor: Colors.black,
          child: IconButton(icon: icon, onPressed: onPressed)),
    );
  }
}
