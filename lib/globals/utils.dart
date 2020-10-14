import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';

Color getColorForString(String str) {
  const initialLetterToColorMap = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange
  ];

  return initialLetterToColorMap[
      str.codeUnitAt(0) % initialLetterToColorMap.length];
}

bool equalsIgnoreCase(String string1, String string2) {
  return string1?.toLowerCase() == string2?.toLowerCase();
}

bool stringContains(String text, String pattern) {
  return text.toLowerCase().trim().contains(pattern.trim().toLowerCase());
}

void removeNullEntriesFromMap(Map map) {
  if (map != null) {
    map.removeWhere((k, v) => v == null);
  }
}

String decodeBase64(String str) {
  //'-', '+' 62nd char of encoding,  '_', '/' 63rd char of encoding
  String output = str.replaceAll('-', '+').replaceAll('_', '/');
  switch (output.length % 4) {
    // Pad with trailing '='
    case 0: // No pad chars in this case
      break;
    case 2: // Two pad chars
      output += '==';
      break;
    case 3: // One pad char
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}

Map<String, dynamic> jsonMapFromString(String jsonString) =>
    jsonDecode(jsonString);
