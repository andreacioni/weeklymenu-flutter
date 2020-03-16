import 'package:flutter/foundation.dart';
class RecipeIngredient with ChangeNotifier {
  String ingredientId;
  double quantity;
  String unitOfMeasure;
  bool freezed;

  RecipeIngredient({@required this.ingredientId, name, this.quantity, this.unitOfMeasure, this.freezed});
}

class Ingredient with ChangeNotifier {
  String id;
  String name;

  Ingredient({this.id, this.name});
}