import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal.g.dart';

@JsonEnum(alwaysCreate: true)
enum Meal {
  @JsonValue('Breakfast')
  Breakfast,
  @JsonValue('Lunch')
  Lunch,
  @JsonValue('Dinner')
  Dinner
}

extension MealExtension on Meal {
  String? get value => _$MealEnumMap[this];

  IconData get icon {
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
