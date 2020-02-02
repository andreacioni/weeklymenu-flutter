class RecipeIngredient extends Ingredient {
  double quantity;
  String unitOfMeasure;

  RecipeIngredient({name, this.quantity, this.unitOfMeasure}) : super(name: name);
}

class Ingredient {
  String name;

  Ingredient({this.name});
}