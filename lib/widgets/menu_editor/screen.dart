import 'package:flutter/material.dart';


import '../../models/enums/meals.dart';

class MenuEditorScreen extends StatelessWidget {

  final DateTime _day;
  final Map<Meal, List<String>> _menuByMeal;

  MenuEditorScreen(this._day, this._menuByMeal);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_day.toString()),
      ),
    );
  }
}