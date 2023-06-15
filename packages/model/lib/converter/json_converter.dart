import 'dart:ui';

import 'package:common/date.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

import '../enums/meal.dart';

class DateConverter implements JsonConverter<Date, String> {
  static final _dateParser = DateFormat('y-M-d');

  const DateConverter();

  @override
  Date fromJson(String json) => Date.parse(_dateParser, json);

  @override
  String toJson(Date date) => _dateParser.format(date.toDateTime);
}

class MealConverter implements JsonConverter<Meal?, String?> {
  const MealConverter();

  @override
  Meal? fromJson(String? json) =>
      Meal.values.firstWhereOrNull((e) => e.value == json);

  @override
  String? toJson(Meal? obj) => obj?.value;
}

class ColorConverter implements JsonConverter<Color?, int?> {
  const ColorConverter();

  @override
  Color? fromJson(int? json) => json != null ? Color(json) : null;

  @override
  int? toJson(Color? obj) => obj?.value;
}
