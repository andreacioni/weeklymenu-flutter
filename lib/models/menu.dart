import 'package:intl/intl.dart';

import '../globals/utils.dart';
import './enums/meals.dart';

class Menu {
  static final _dateParser = DateFormat('y-M-d');

  String id;
  DateTime date;
  Meal meal;
  List<String> recipes;

  Menu({this.id, this.date, this.meal, this.recipes});

  factory Menu.fromJSON(Map<dynamic, dynamic> jsonMap) {
    return Menu(
      id: jsonMap['_id'],
      date: _dateParser.parse(jsonMap['date']),
      meal: Meal.values.firstWhere((m) => equalsIgnoreCase(m.value, (jsonMap['meal'] as String)), orElse: () => null),
      recipes: jsonMap['recipes'].cast<String>()
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      '_id': id,
      'date': _dateParser.format(date),
      'meal': meal.value,
      'recipes': recipes
    };
  }


}

