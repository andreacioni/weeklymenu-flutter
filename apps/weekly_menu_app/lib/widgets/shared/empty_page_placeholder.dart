import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class EmptyPagePlaceholder extends StatelessWidget {
  static const double DEFAULT_TEXT_SIZE = 25;
  static const double DEFAULT_ICON_SIZE = 150;

  final IconData icon;
  final String text;
  final EdgeInsets? margin;
  final double iconSize;
  final double textSize;
  final double? sizeRate;

  const EmptyPagePlaceholder({
    Key? key,
    required this.icon,
    required this.text,
    this.iconSize = DEFAULT_ICON_SIZE,
    this.textSize = DEFAULT_TEXT_SIZE,
    this.margin,
    this.sizeRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var iSize = iconSize;
    var tSize = textSize;

    if (sizeRate != null) {
      iSize = sizeRate! * DEFAULT_ICON_SIZE;
      tSize = sizeRate! * DEFAULT_TEXT_SIZE;
    }

    return Container(
      margin: margin,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: iSize,
              color: Colors.grey.shade300,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: tSize,
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
