import 'package:flutter/material.dart';

final pageViewLimitDays = 2 * 2;

const todayColor = Color.fromRGBO(183, 223, 189, 1);
const pastColor = Color.fromRGBO(178, 185, 222, 1);

const ID_FIELD = '_id';
const INSERT_TIMESTAMP_FIELD = 'insert_timestamp';
const UPDATE_TIMESTAMP_FIELD = 'update_timestamp';

const String emailValidationRegex =
    "(^[a-zA-Z0-9_.+-]{2,}@[a-zA-Z0-9-.]{2,}\.[a-zA-Z]{2,}\$)";

const String alloweSpecialCharacters = "?\$#!'\"=%&/\/\(\)\[\]\{\}";
const String passwordValidationRegex = "^[a-zA-Z0-9]{7,20}\$";

class SharedPreferencesKeys {
  static final String tokenSharedPreferencesKey = "token";
  static final String emailSharedPreferencesKey = "username";
  static final String passwordSharedPreferencesKey = "password";
}
