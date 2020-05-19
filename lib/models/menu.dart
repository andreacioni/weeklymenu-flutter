import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../datasource/network.dart';
import '../globals/utils.dart';
import './enums/meals.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu with ChangeNotifier {
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();

  static final _dateParser = DateFormat('y-M-d');

  @JsonKey(name: '_id')
  String id;
  @JsonKey(toJson: dateToJson, fromJson: dateFromJson)
  DateTime date;
  Meal meal;

  @JsonKey(includeIfNull: false, defaultValue: [])
  List<String> recipes;

  Menu({this.id, this.date, this.meal, this.recipes});

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);

  static String dateToJson(DateTime date) =>
    _dateParser.format(date);

  static DateTime dateFromJson(String date) =>
    _dateParser.parse(date);
  

  Future<void> removeRecipeFromMeal(Meal meal) {}
}
