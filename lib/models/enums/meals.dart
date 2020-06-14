import 'package:flutter/material.dart';

enum Meal {
  Breakfast,
  Lunch,
  Dinner
}

extension MealValue on Meal {
  String get value => this.toString().split(".").last;
}

extension MealIcon on Meal {
  IconData get icon  {
    switch (this) {
      case Meal.Breakfast:
        return Icons.local_cafe;
      case Meal.Lunch:
        return Icons.fastfood;
      case Meal.Dinner:
        return Icons.local_bar;
      default:
        return Icons.sentiment_dissatisfied;
    }
  }
}