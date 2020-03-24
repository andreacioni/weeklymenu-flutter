import 'package:flutter/foundation.dart';

class Ingredient with ChangeNotifier {
  String id;
  String name;

  Ingredient({this.id, this.name});

  factory Ingredient.fromJSON(Map<String, dynamic> jsonMap) {
    return Ingredient(
      id: jsonMap['_id'],
      name: jsonMap['name'],
    );
  }
}
