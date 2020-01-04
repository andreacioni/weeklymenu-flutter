enum Meal {
  Breakfast,
  Lunch,
  Dinner
}

extension MealValue on Meal {
  String get value => this.toString().split(".").last;
}