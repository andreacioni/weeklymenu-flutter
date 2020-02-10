import './unit_of_measure.dart';

class RecipeIngredient extends Ingredient {
  double quantity;
  UnitOfMeasure unitOfMeasure;

  RecipeIngredient({id, name, this.quantity, this.unitOfMeasure}) : super(id: id, name: name);
}

class Ingredient {
  String id;
  String name;

  Ingredient({this.id, this.name});
}