import 'package:flutter/material.dart';
import '../../models/enums/meals.dart';

class MealDropdown extends StatefulWidget {

  MealDropdown();

  @override
  _MealDropdownState createState() => _MealDropdownState();
}

class _MealDropdownState extends State<MealDropdown> {
  
  Meal _dropdownValue = Meal.Breakfast;

  DropdownMenuItem<Meal> _createDropDownItem(Meal meal) {
    return DropdownMenuItem<Meal>(
      child: Text(meal.value), 
      value: meal,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Meal", style: TextStyle(fontSize: 18),),
        DropdownButton<Meal>(
          value: _dropdownValue,
          items: Meal.values.map((meal) => _createDropDownItem(meal)).toList(),
          onChanged: (s) {
            setState(() {
              _dropdownValue = s;
            });
          },
        ),
      ],
    );
  }
}