import 'package:flutter/material.dart';
import '../models/meals.dart';

class MealDropdown extends StatelessWidget {

  final List<String> _meals = const [
    Meals.BREAKFAST,
    Meals.LUNCH,
    Meals.DINNER,
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: _meals.map((meal) => DropdownMenuItem(child: Text(meal), value: meal,),).toList(),
      onChanged: (s) {},
    );
  }
}