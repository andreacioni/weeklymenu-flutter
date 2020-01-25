class RecipeIngredient extends Ingredient {
  final double quantity;
  final String unitOfMeasure;

  RecipeIngredient({name, this.quantity, this.unitOfMeasure}) : super(name: name);
}

class Ingredient {
  final String name;

  Ingredient({this.name});
}