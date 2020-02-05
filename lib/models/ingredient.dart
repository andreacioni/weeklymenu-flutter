import './unit_of_measure.dart';

class RecipeIngredient extends Ingredient {
  double quantity;
  UnitOfMeasure unitOfMeasure;

  RecipeIngredient({name, this.quantity, this.unitOfMeasure}) : super(name: name);
}

class Ingredient {
  String name;

  Ingredient({this.name});
}