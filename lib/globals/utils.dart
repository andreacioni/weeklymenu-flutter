import 'dart:math';

import 'package:flutter/material.dart';

Color getColorForString(String str) {
  const initialLetterToColorMap = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange
   ];


  return initialLetterToColorMap[str.codeUnitAt(0) % initialLetterToColorMap.length];
}