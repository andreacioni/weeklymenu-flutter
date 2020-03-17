import 'package:flutter/foundation.dart';

class Ingredient with ChangeNotifier {
  String id;
  String name;

  Ingredient({this.id, this.name});
}